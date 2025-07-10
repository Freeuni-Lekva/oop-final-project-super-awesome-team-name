CREATE DATABASE IF NOT EXISTS quiz_app;

use quiz_app;

DROP TABLE IF EXISTS quiz_attempts;
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

-- for quiz attempts
CREATE TABLE quiz_attempts (
                               attempt_id INT AUTO_INCREMENT PRIMARY KEY,
                               user_name VARCHAR(50),
                               quiz_id INT NOT NULL,
                               score INT,
                               total_questions INT,
                               time_taken INT,
                               attempt_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                               answers TEXT,
                               correct_answers TEXT,
                               is_practice_mode BOOLEAN DEFAULT FALSE,
                               FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE
);