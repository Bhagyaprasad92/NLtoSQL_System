package com.nl2sql.backend.dto;

import java.util.List;
import java.util.Map;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class Nl2SqlResponse {
    private String userQuery;
    private String generatedSql;
    private List<Map<String, Object>> result;
}
