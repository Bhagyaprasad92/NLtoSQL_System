package com.nl2sql.backend.controller;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.nl2sql.backend.dto.Auth;
import com.nl2sql.backend.dto.ForgotPassReq;
import com.nl2sql.backend.dto.Login;
import com.nl2sql.backend.dto.MsgRes;
import com.nl2sql.backend.dto.Register;
import com.nl2sql.backend.dto.ResetPassReq;
import com.nl2sql.backend.dto.VerifyOtpReq;
import com.nl2sql.backend.service.AuthService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class AuthController {
    private final AuthService aS;

    @PostMapping("/register")
    public Auth register(@RequestBody Register req) {
        return aS.register(req);
    }

    @PostMapping("/login")
    public Auth login(@RequestBody Login req) {
        return aS.login(req);
    }

    @PostMapping("/forgot-password")
    public MsgRes forgotPassword(@RequestBody ForgotPassReq req) {
        return aS.forgotPassword(req);
    }

    @PostMapping("/verify-otp")
    public MsgRes verifyOtp(@RequestBody VerifyOtpReq req) {
        return aS.verifyOtp(req);
    }

    @PostMapping("/reset-password")
    public MsgRes resetPassword(@RequestBody ResetPassReq req) {
        return aS.resetPassword(req);
    }
}
