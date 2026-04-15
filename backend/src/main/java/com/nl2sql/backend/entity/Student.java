package com.nl2sql.backend.entity;

import java.time.LocalDateTime;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "students")
@Data
public class Student {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "Roll_No", unique = true, nullable = false)
    private String rollNo;

    @Column(name = "Full_Name")
    private String fullName;

    @Column(name = "Photo_URL", columnDefinition = "TEXT")
    private String photoUrl;

    @Column(name = "Date_of_Birth")
    private String dateOfBirth;

    @Column(name = "Gender")
    private String gender;

    @Column(name = "Father_Name")
    private String fatherName;

    @Column(name = "Mother_Name")
    private String motherName;

    @Column(name = "Caste_Category")
    private String casteCategory;

    @Column(name = "Admission_Date")
    private String admissionDate;

    @Column(name = "Course_Completion_Year")
    private Integer courseCompletionYear;

    @Column(name = "Parent_Mobile")
    private Long parentMobile;

    @Column(name = "Student_Mobile")
    private Long studentMobile;

    @Column(name = "Email")
    private String email;

    @Column(name = "Course")
    private String course;

    @Column(name = "Branch")
    private String branch;

    @Column(name = "Section")
    private String section;

    @Column(name = "Aadhar_No")
    private String aadharNo;

    @Column(name = "SSC")
    private Double ssc;

    @Column(name = "Inter")
    private Double inter;

    @Column(name = "created_at", insertable = false, updatable = false)
    private LocalDateTime createdAt;
}
