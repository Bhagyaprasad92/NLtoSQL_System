package com.nl2sql.backend.dto;
import lombok.Data;

@Data
public class ResetPassReq {
    private String email;
    private String otp;
    private String newPassword;
}
