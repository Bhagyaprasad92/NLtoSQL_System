package com.nl2sql.backend.service;

import java.util.List;
import java.util.Map;
import org.springframework.http.*;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nl2sql.backend.dto.Nl2SqlResponse;

import org.springframework.beans.factory.annotation.Value;

@Service
public class Nl2SqlService {

    private final JdbcTemplate jdbcTemplate;
    private final ObjectMapper objectMapper = new ObjectMapper();
    @Value("${GEMINI_API_KEY}")
    private String geminiApiKey;

    @Value("${GEMINI_API_URL}")
    private String geminiApiUrl;
    public Nl2SqlService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public Nl2SqlResponse processNaturalLanguageQuery(String userQuery) {
        String sql = generateSqlFromGemini(userQuery);
        validateSql(sql);

        List<Map<String, Object>> results = jdbcTemplate.queryForList(sql);

        return new Nl2SqlResponse(userQuery, sql, results);
    }

    private String generateSqlFromGemini(String userQuery) {
        try {
            RestTemplate restTemplate = new RestTemplate();

            String prompt = """
                    You are an expert SQL generator.

                    Convert the given natural language query into a valid MySQL SQL query.

                    Database name: nl2sql_student

                    Table: students
                    Columns:
                    - id
                    - roll_no
                    - full_name
                    - date_of_birth
                    - gender
                    - father_name
                    - mother_name
                    - caste_category
                    - admission_date
                    - course_completion_year
                    - parent_mobile
                    - student_mobile
                    - email
                    - course
                    - branch
                    - photo_url
                    - section
                    - aadhar_no
                    - ssc
                    - inter
                    - created_at

                    Rules:
                    1. Only generate SELECT queries.
                    2. Do NOT generate INSERT, UPDATE, DELETE, DROP.
                    3. Use correct column names exactly as given.
                    4. Use WHERE conditions when needed.
                    5. Use LIKE for partial matches.
                    6. Do NOT explain anything.
                    7. Return ONLY SQL query.

                    User Query:
                    """ + userQuery;

            String requestBody = """
                    {
                      "contents": [
                        {
                          "parts": [
                            {
                              "text": %s
                            }
                          ]
                        }
                      ]
                    }
                    """.formatted(objectMapper.writeValueAsString(prompt));

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            HttpEntity<String> entity = new HttpEntity<>(requestBody, headers);

            ResponseEntity<String> response = restTemplate.exchange(
                    geminiApiUrl + "?key=" + geminiApiKey,
                    HttpMethod.POST,
                    entity,
                    String.class);

            JsonNode root = objectMapper.readTree(response.getBody());
            JsonNode textNode = root.path("candidates")
                    .get(0)
                    .path("content")
                    .path("parts")
                    .get(0)
                    .path("text");

            if (textNode.isMissingNode() || textNode.asText().isBlank()) {
                throw new RuntimeException("Gemini did not return SQL");
            }

            return cleanSql(textNode.asText());

        } catch (Exception e) {
            throw new RuntimeException("Failed to generate SQL from Gemini: " + e.getMessage(), e);
        }
    }

    private String cleanSql(String sql) {
        String cleaned = sql.trim();

        // Remove markdown fences if Gemini returns ```sql ... ```
        cleaned = cleaned.replaceAll("(?i)```sql", "");
        cleaned = cleaned.replaceAll("```", "");
        cleaned = cleaned.trim();

        // Remove trailing semicolon optionally
        if (cleaned.endsWith(";")) {
            cleaned = cleaned.substring(0, cleaned.length() - 1).trim();
        }

        return cleaned;
    }

    private void validateSql(String sql) {
        String lowerSql = sql.toLowerCase().trim();

        if (!lowerSql.startsWith("select")) {
            throw new RuntimeException("Only SELECT queries are allowed");
        }

        if (lowerSql.contains("insert ")
                || lowerSql.contains("update ")
                || lowerSql.contains("delete ")
                || lowerSql.contains("drop ")
                || lowerSql.contains("alter ")
                || lowerSql.contains("truncate ")) {
            throw new RuntimeException("Unsafe SQL detected");
        }

        if (!lowerSql.contains(" from students")) {
            throw new RuntimeException("Only students table can be queried");
        }
    }
}