package com.nl2sql.backend.service;

import java.time.LocalDateTime;
import java.util.Random;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.nl2sql.backend.dto.Auth;
import com.nl2sql.backend.dto.Login;
import com.nl2sql.backend.dto.Register;
import com.nl2sql.backend.dto.ForgotPassReq;
import com.nl2sql.backend.dto.VerifyOtpReq;
import com.nl2sql.backend.dto.ResetPassReq;
import com.nl2sql.backend.dto.MsgRes;

import com.nl2sql.backend.entity.User;
import com.nl2sql.backend.entity.PasswordResetOtp;

import com.nl2sql.backend.repo.UserRepo;
import com.nl2sql.backend.repo.PasswordResetOtpRepo;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepo userRepo;
    private final PasswordEncoder passEncoder;
    private final PasswordResetOtpRepo otpRepo;
    private final MailService mailService;

    public Auth register(Register req) {

        if (userRepo.existsByEmail(req.getEmail())) {
            throw new RuntimeException("Email already exists");
        }

        User u = new User();
        u.setName(req.getName());
        u.setEmail(req.getEmail());
        u.setPassword(passEncoder.encode(req.getPassword()));
        u.setRole("USER");

        User saved = userRepo.save(u);

        return new Auth(
            "Register success",
            saved.getId(),
            saved.getName(),
            saved.getEmail(),
            saved.getRole()
        );
    }

    public Auth login(Login req) {
        User u = userRepo.findByEmail(req.getEmail())
                .orElseThrow(() -> new RuntimeException("Invalid email"));

        if (!passEncoder.matches(req.getPassword(), u.getPassword())) {
            throw new RuntimeException("Wrong password");
        }

        return new Auth(
            "Login success",
            u.getId(),
            u.getName(),
            u.getEmail(),
            u.getRole()
        );
    }

    public MsgRes forgotPassword(ForgotPassReq req) {

        User user = userRepo.findByEmail(req.getEmail())
                .orElseThrow(() -> new RuntimeException("Email not found"));

        String otp = String.format("%06d", new Random().nextInt(999999));

        PasswordResetOtp obj = new PasswordResetOtp();
        obj.setEmail(user.getEmail());
        obj.setOtp(otp);
        obj.setExpiryTime(LocalDateTime.now().plusMinutes(10));
        obj.setUsed(false);

        otpRepo.save(obj);

        mailService.sendOtp(user.getEmail(), otp);

        return new MsgRes("OTP sent to email");
    }

    public MsgRes verifyOtp(VerifyOtpReq req) {

        PasswordResetOtp obj = otpRepo
                .findTopByEmailAndOtpAndUsedFalseOrderByIdDesc(
                        req.getEmail(), req.getOtp())
                .orElseThrow(() -> new RuntimeException("Invalid OTP"));

        if (obj.getExpiryTime().isBefore(LocalDateTime.now())) {
            throw new RuntimeException("OTP expired");
        }

        return new MsgRes("OTP verified");
    }

    public MsgRes resetPassword(ResetPassReq req) {

        PasswordResetOtp obj = otpRepo
                .findTopByEmailAndOtpAndUsedFalseOrderByIdDesc(
                        req.getEmail(), req.getOtp())
                .orElseThrow(() -> new RuntimeException("Invalid OTP"));

        if (obj.getExpiryTime().isBefore(LocalDateTime.now())) {
            throw new RuntimeException("OTP expired");
        }

        User user = userRepo.findByEmail(req.getEmail())
                .orElseThrow(() -> new RuntimeException("User not found"));

        user.setPassword(passEncoder.encode(req.getNewPassword()));
        userRepo.save(user);

        obj.setUsed(true);
        otpRepo.save(obj);

        return new MsgRes("Password reset successful");
    }
}