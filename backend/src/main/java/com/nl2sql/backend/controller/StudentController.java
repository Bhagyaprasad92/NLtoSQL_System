package com.nl2sql.backend.controller;

import java.util.List;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.nl2sql.backend.dto.StudentDashboard;
import com.nl2sql.backend.service.StudentService;

@RestController
@RequestMapping("/api/students")
@CrossOrigin(origins = "*")
public class StudentController {
    private final StudentService studentService;

    public StudentController(StudentService studentService) {
        this.studentService = studentService;
    }

    @GetMapping("/dashboard")
    public List<StudentDashboard> getDashboardStudents() {
        return studentService.getDashboardStudents();
    }

    @GetMapping("/{rollNo}")
    public Object getStudentByRollNo(@PathVariable String rollNo) {
        return studentService.getStudentByRollNo(rollNo);
    }
}
