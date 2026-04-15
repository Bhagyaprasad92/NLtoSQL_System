CREATE DATABASE IF NOT EXISTS nl2sql_student;
USE nl2sql_student;

CREATE TABLE users(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(255),
    role VARCHAR(50) DEFAULT 'USER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    roll_no VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(255),
    date_of_birth VARCHAR(20),
    gender VARCHAR(10),
    father_name VARCHAR(255),
    mother_name VARCHAR(255),
    caste_category VARCHAR(50),
    admission_date VARCHAR(20),
    course_completion_year INT,
    parent_mobile BIGINT,
    student_mobile BIGINT,
    email VARCHAR(100),
    course VARCHAR(50),
    branch VARCHAR(50),
    photo_url TEXT,
    section VARCHAR(5),
    aadhar_no VARCHAR(20),
    ssc DECIMAL(5,2),
    inter DECIMAL(5,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE query_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    user_query TEXT,
    generated_sql TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE password_reset_otp (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL,
    otp VARCHAR(10) NOT NULL,
    expiry_time TIMESTAMP NOT NULL,
    used BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);