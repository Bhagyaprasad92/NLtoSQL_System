package com.nl2sql.backend.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class Nl2SqlRequest {

    @NotBlank(message = "Query cannot be empty")
    private String query;
}
