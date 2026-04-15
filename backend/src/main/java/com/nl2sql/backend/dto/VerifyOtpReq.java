package com.nl2sql.backend.dto;

import lombok.Data;

@Data
public class VerifyOtpReq {
    private String email;
    private String otp;
}
