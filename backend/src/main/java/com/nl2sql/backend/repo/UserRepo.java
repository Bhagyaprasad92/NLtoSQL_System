package com.nl2sql.backend.repo;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import com.nl2sql.backend.entity.User;

public interface UserRepo extends JpaRepository<User, Integer>{
    Optional<User> findByEmail(String email);
    boolean existsByEmail(String email);
}

