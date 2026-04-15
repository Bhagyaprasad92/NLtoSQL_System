package com.nl2sql.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class Auth {
    private String msg;
    private Long id;
    private String name;
    private String email;
    private String role;
}
