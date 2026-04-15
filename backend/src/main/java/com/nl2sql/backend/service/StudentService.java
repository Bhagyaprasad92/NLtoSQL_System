package com.nl2sql.backend.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.nl2sql.backend.dto.StudentDashboard;
import com.nl2sql.backend.repo.StudentRepo;

@Service
public class StudentService {
    private final StudentRepo studentRepository;

    public StudentService(StudentRepo studentRepository) {
        this.studentRepository = studentRepository;
    }

    public List<StudentDashboard> getDashboardStudents() {
        return studentRepository.findAllForDashboard();
    }

    public Object getStudentByRollNo(String rollNo) {
        return studentRepository.findByRollNo(rollNo);
    }
}
