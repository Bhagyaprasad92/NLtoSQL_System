package com.nl2sql.backend.repo;

import org.springframework.data.jpa.repository.JpaRepository;
import com.nl2sql.backend.entity.PasswordResetOtp;

import java.util.Optional;

public interface PasswordResetOtpRepo extends JpaRepository<PasswordResetOtp, Long> {
    Optional<PasswordResetOtp> findTopByEmailAndOtpAndUsedFalseOrderByIdDesc(String email, String otp);
    Optional<PasswordResetOtp> findTopByEmailAndUsedFalseOrderByIdDesc(String email);
}