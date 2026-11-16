-- Week 1 Database Assignment
-- Topic: Digital Learning Management System
-- Database: digital_learning_db
-- Description: Stores students, instructors, courses, enrolments,
-- lessons, attendance, learning progress, and certificates.

CREATE DATABASE IF NOT EXISTS digital_learning_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE digital_learning_db;

-- 1. Students who register for learning programmes
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    registration_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    status ENUM('active', 'inactive') NOT NULL DEFAULT 'active'
);

-- 2. Instructors who teach courses
CREATE TABLE instructors (
    instructor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    specialization VARCHAR(100)
);

-- 3. Courses offered by the learning hub
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    instructor_id INT,
    start_date DATE,
    end_date DATE,
    course_level ENUM('beginner', 'intermediate', 'advanced')
        NOT NULL DEFAULT 'beginner',
    FOREIGN KEY (instructor_id)
        REFERENCES instructors(instructor_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    CHECK (end_date IS NULL OR start_date IS NULL OR end_date >= start_date)
);

-- 4. Students enrolled in courses
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    enrollment_status ENUM('enrolled', 'completed', 'withdrawn')
        NOT NULL DEFAULT 'enrolled',
    FOREIGN KEY (student_id)
        REFERENCES students(student_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    UNIQUE (student_id, course_id)
);

-- 5. Lessons belonging to each course
CREATE TABLE lessons (
    lesson_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    lesson_title VARCHAR(150) NOT NULL,
    lesson_description TEXT,
    lesson_order INT NOT NULL,
    FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    UNIQUE (course_id, lesson_order)
);

-- 6. Attendance recorded for enrolled students
CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    attendance_status ENUM('present', 'absent', 'late')
        NOT NULL DEFAULT 'present',
    FOREIGN KEY (enrollment_id)
        REFERENCES enrollments(enrollment_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    UNIQUE (enrollment_id, attendance_date)
);

-- 7. Progress made by a student on each lesson
CREATE TABLE student_progress (
    progress_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL,
    lesson_id INT NOT NULL,
    completion_status ENUM('not_started', 'in_progress', 'completed')
        NOT NULL DEFAULT 'not_started',
    score DECIMAL(5,2),
    last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (enrollment_id)
        REFERENCES enrollments(enrollment_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (lesson_id)
        REFERENCES lessons(lesson_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    UNIQUE (enrollment_id, lesson_id),
    CHECK (score IS NULL OR (score >= 0 AND score <= 100))
);

-- 8. Certificates issued after course completion
CREATE TABLE certificates (
    certificate_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL UNIQUE,
    certificate_code VARCHAR(50) NOT NULL UNIQUE,
    issue_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    FOREIGN KEY (enrollment_id)
        REFERENCES enrollments(enrollment_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
