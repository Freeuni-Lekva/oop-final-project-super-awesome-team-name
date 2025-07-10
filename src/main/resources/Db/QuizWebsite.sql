CREATE DATABASE IF NOT EXISTS QuizWebsite;

USE QuizWebsite;

DROP TABLE IF EXISTS users;

CREATE TABLE users (
    name VARCHAR(100) PRIMARY KEY,
    hashedpassword VARCHAR(255) NOT NULL,
    isadmin boolean NOT NULL
);

DROP TABLE IF EXISTS announcements;

CREATE TABLE announcements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    text TEXT NOT NULL,
    date TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP(3)
);

DROP TABLE IF EXISTS questions;

DROP TABLE IF EXISTS quizzes;

CREATE TABLE quizzes (
                         id INT AUTO_INCREMENT PRIMARY KEY,
                         name VARCHAR(255),
                         description TEXT,
                         num_questions INT,
                         random_order BOOLEAN,
                         one_page BOOLEAN,
                         immediate_correction BOOLEAN,
                         practice_mode BOOLEAN,
                         creator_username VARCHAR(255)
);



CREATE TABLE questions (
                           id INT AUTO_INCREMENT PRIMARY KEY,
                           quiz_id INT,
                           question_text TEXT,
                           question_type VARCHAR(100),
                           possible_answers TEXT,
                           correct_answer TEXT,
                           imageURL TEXT,
                           order_matters BOOLEAN,
                           FOREIGN KEY (quiz_id) REFERENCES quizzes(id)
);


