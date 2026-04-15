package com.nl2sql.backend.repo;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import com.nl2sql.backend.dto.StudentDashboard;
import com.nl2sql.backend.entity.Student;

public interface StudentRepo extends JpaRepository<Student, Integer> {
    @Query("SELECT new com.nl2sql.backend.dto.StudentDashboard(s.rollNo, s.photoUrl) FROM Student s")
    List<StudentDashboard> findAllForDashboard();

    Student findByRollNo(String rollNo);
}
