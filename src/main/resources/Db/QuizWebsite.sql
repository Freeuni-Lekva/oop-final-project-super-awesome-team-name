CREATE DATABASE IF NOT EXISTS QuizWebsite;

use QuizWebsite;

DROP TABLE IF EXISTS user_achievements;
DROP TABLE IF EXISTS quiz_attempts;
DROP TABLE IF EXISTS announcements;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS achievements;
DROP TABLE IF EXISTS quizzes;
DROP TABLE IF EXISTS users;


CREATE TABLE users (
                       name VARCHAR(100) PRIMARY KEY,
                       hashedpassword VARCHAR(255) NOT NULL,
                       isadmin BOOLEAN NOT NULL
);

CREATE TABLE achievements (
                              achievement_id INT AUTO_INCREMENT PRIMARY KEY,
                              name VARCHAR(100) NOT NULL,
                              description TEXT NOT NULL,
                              icon_url VARCHAR(500),
                              condition_type ENUM('quiz_count', 'quiz_created', 'high_score', 'practice_mode', 'perfect_score') NOT NULL,
                              condition_value INT DEFAULT 0, -- threshold value for the condition
                              created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

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


CREATE TABLE user_achievements (
                                   user_achievement_id INT AUTO_INCREMENT PRIMARY KEY,
                                   user_name VARCHAR(100) NOT NULL,
                                   achievement_id INT NOT NULL,
                                   earned_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                   FOREIGN KEY (user_name) REFERENCES users(name) ON DELETE CASCADE,
                                   FOREIGN KEY (achievement_id) REFERENCES achievements(achievement_id) ON DELETE CASCADE,
                                   UNIQUE KEY unique_user_achievement (user_name, achievement_id)
);


CREATE TABLE announcements (
                               id INT AUTO_INCREMENT PRIMARY KEY,
                               title VARCHAR(255) NOT NULL,
                               name VARCHAR(100) NOT NULL,
                               text TEXT NOT NULL,
                               date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE OR REPLACE VIEW quiz_statistics AS
SELECT
    q.id,
    q.name,
    q.creator_username,
    COUNT(qa.attempt_id) as total_attempts,
    COUNT(DISTINCT qa.user_name) as unique_users,
    AVG(qa.score / qa.total_questions * 100) as average_score,
    MAX(qa.score / qa.total_questions * 100) as highest_score,
    MIN(qa.time_taken) as fastest_time,
    AVG(qa.time_taken) as average_time
FROM quizzes q
         LEFT JOIN quiz_attempts qa ON q.id = qa.quiz_id
WHERE qa.is_practice_mode = FALSE OR qa.is_practice_mode IS NULL
GROUP BY q.id, q.name, q.creator_username;

-- User performance view
CREATE OR REPLACE VIEW user_performance AS
SELECT
    u.name,
    COUNT(qa.attempt_id) as total_attempts,
    COUNT(DISTINCT qa.quiz_id) as quizzes_taken,
    AVG(qa.score / qa.total_questions * 100) as average_score,
    MAX(qa.score / qa.total_questions * 100) as best_score,
    COUNT(ach.user_achievement_id) as total_achievements,
    MAX(qa.attempt_date) as last_quiz_date
FROM users u
         LEFT JOIN quiz_attempts qa ON u.name = qa.user_name AND qa.is_practice_mode = FALSE
         LEFT JOIN user_achievements ach ON u.name = ach.user_name
GROUP BY u.name;


CREATE INDEX idx_quiz_attempts_user_date ON quiz_attempts(user_name, attempt_date DESC);
CREATE INDEX idx_quiz_attempts_quiz_score ON quiz_attempts(quiz_id, score DESC);
CREATE INDEX idx_user_achievements_user ON user_achievements(user_name);
CREATE INDEX idx_achievements_condition ON achievements(condition_type, condition_value);
CREATE INDEX idx_questions_quiz ON questions(quiz_id);




DROP TABLE IF EXISTS FriendRequests;

CREATE TABLE FriendRequests (
                                id             INT AUTO_INCREMENT PRIMARY KEY,
                                requester_name VARCHAR(100) NOT NULL,
                                requestee_name VARCHAR(100) NOT NULL,
                                status         ENUM('PENDING','ACCEPTED','DECLINED') NOT NULL DEFAULT 'PENDING',
                                created_at     TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
                                updated_at     TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
                                    ON UPDATE CURRENT_TIMESTAMP(3),
                                UNIQUE(requester_name, requestee_name),
                                FOREIGN KEY (requester_name) REFERENCES users(name),
                                FOREIGN KEY (requestee_name) REFERENCES users(name)
);

DROP TABLE IF EXISTS Friendships;

CREATE TABLE Friendships (
                             user_name   VARCHAR(100) NOT NULL,
                             friend_name VARCHAR(100) NOT NULL,
                             since       TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
                             PRIMARY KEY (user_name, friend_name),
                             FOREIGN KEY (user_name)   REFERENCES users(name),
                             FOREIGN KEY (friend_name) REFERENCES users(name)
);


-- Add this to your QuizWebsite.sql file

CREATE TABLE messages (
                          message_id INT AUTO_INCREMENT PRIMARY KEY,
                          sender_name VARCHAR(100) NOT NULL,
                          recipient_name VARCHAR(100) NOT NULL,
                          message_type ENUM('FRIEND_REQUEST', 'CHALLENGE', 'NOTE') NOT NULL,
                          subject VARCHAR(255) NOT NULL,
                          message_text TEXT NOT NULL,
                          is_read BOOLEAN DEFAULT FALSE,
                          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- For friend requests
                          friend_request_id INT NULL,

    -- For challenges
                          quiz_id INT NULL,
                          challenger_score INT NULL,
                          challenger_total_questions INT NULL,

                          FOREIGN KEY (sender_name) REFERENCES users(name) ON DELETE CASCADE,
                          FOREIGN KEY (recipient_name) REFERENCES users(name) ON DELETE CASCADE,
                          FOREIGN KEY (friend_request_id) REFERENCES FriendRequests(id) ON DELETE CASCADE,
                          FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE,

                          INDEX idx_recipient_date (recipient_name, created_at DESC),
                          INDEX idx_sender_date (sender_name, created_at DESC)
);
SELECT 'QuizWebsite database setup completed successfully!' as message;