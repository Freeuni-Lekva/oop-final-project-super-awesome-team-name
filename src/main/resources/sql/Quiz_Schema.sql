CREATE DATABASE IF NOT EXISTS quiz_app;

use quiz_app;

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
