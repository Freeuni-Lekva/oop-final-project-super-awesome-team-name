-- Complete QuizWebsite Database Schema
-- Updated to include Person 3 (Quiz Taking, History & Achievements) tables

CREATE DATABASE IF NOT EXISTS QuizWebsite;
USE QuizWebsite;

-- =====================================================
-- EXISTING TABLES (Person 1 - Users & Admin)
-- =====================================================

DROP TABLE IF EXISTS user_achievements;
DROP TABLE IF EXISTS quiz_attempts;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS quizzes;
DROP TABLE IF EXISTS achievements;
DROP TABLE IF EXISTS announcements;
DROP TABLE IF EXISTS users;

-- Users table (Person 1 responsibility)
CREATE TABLE users (
                       name VARCHAR(100) PRIMARY KEY,
                       hashedpassword VARCHAR(255) NOT NULL,
                       isadmin BOOLEAN NOT NULL
);

-- Announcements table (Person 1/Admin responsibility)
CREATE TABLE announcements (
                               id INT AUTO_INCREMENT PRIMARY KEY,
                               title VARCHAR(255) NOT NULL,
                               name VARCHAR(100) NOT NULL,
                               text TEXT NOT NULL,
                               date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- NEW TABLES (Person 3 - Quiz Taking & History)
-- =====================================================

-- Quizzes table (shared between Person 2 & Person 3)
CREATE TABLE quizzes (
                         quiz_id INT AUTO_INCREMENT PRIMARY KEY,
                         title VARCHAR(200) NOT NULL,
                         description TEXT,
                         creator_name VARCHAR(100) NOT NULL,
                         created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         is_random_order BOOLEAN DEFAULT FALSE,
                         is_single_page BOOLEAN DEFAULT TRUE,
                         immediate_correction BOOLEAN DEFAULT FALSE,
                         allow_practice_mode BOOLEAN DEFAULT TRUE,
                         FOREIGN KEY (creator_name) REFERENCES users(name) ON DELETE CASCADE
);

-- Questions table (shared between Person 2 & Person 3)
CREATE TABLE questions (
                           question_id INT AUTO_INCREMENT PRIMARY KEY,
                           quiz_id INT NOT NULL,
                           question_text TEXT NOT NULL,
                           question_type ENUM('multiple_choice', 'question_response', 'fill_blank', 'picture_response') NOT NULL,
                           question_order INT NOT NULL,
                           correct_answers JSON NOT NULL,
                           choices JSON,
                           image_url VARCHAR(500),
                           FOREIGN KEY (quiz_id) REFERENCES quizzes(quiz_id) ON DELETE CASCADE
);

-- Quiz attempts table (Person 3 main responsibility)
CREATE TABLE quiz_attempts (
                               attempt_id INT AUTO_INCREMENT PRIMARY KEY,
                               user_name VARCHAR(100) NOT NULL,
                               quiz_id INT NOT NULL,
                               score INT NOT NULL,
                               total_questions INT NOT NULL,
                               time_taken INT NOT NULL, -- in seconds
                               attempt_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                               answers JSON NOT NULL, -- user's answers
                               correct_answers JSON NOT NULL, -- correct answers at time of attempt
                               is_practice_mode BOOLEAN DEFAULT FALSE,
                               FOREIGN KEY (user_name) REFERENCES users(name) ON DELETE CASCADE,
                               FOREIGN KEY (quiz_id) REFERENCES quizzes(quiz_id) ON DELETE CASCADE,
                               INDEX idx_user_quiz (user_name, quiz_id),
                               INDEX idx_attempt_date (attempt_date),
                               INDEX idx_quiz_score (quiz_id, score DESC)
);

-- Achievements table (Person 3 main responsibility)
CREATE TABLE achievements (
                              achievement_id INT AUTO_INCREMENT PRIMARY KEY,
                              name VARCHAR(100) NOT NULL,
                              description TEXT NOT NULL,
                              icon_url VARCHAR(500),
                              condition_type ENUM('quiz_count', 'quiz_created', 'high_score', 'practice_mode', 'perfect_score') NOT NULL,
                              condition_value INT DEFAULT 0, -- threshold value for the condition
                              created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- User achievements table (Person 3 main responsibility)
CREATE TABLE user_achievements (
                                   user_achievement_id INT AUTO_INCREMENT PRIMARY KEY,
                                   user_name VARCHAR(100) NOT NULL,
                                   achievement_id INT NOT NULL,
                                   earned_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                   FOREIGN KEY (user_name) REFERENCES users(name) ON DELETE CASCADE,
                                   FOREIGN KEY (achievement_id) REFERENCES achievements(achievement_id) ON DELETE CASCADE,
                                   UNIQUE KEY unique_user_achievement (user_name, achievement_id)
);

-- =====================================================
-- SAMPLE DATA FOR TESTING
-- =====================================================

-- Insert sample users (including existing admin pattern)
INSERT INTO users (name, hashedpassword, isadmin) VALUES
                                                      ('Admin', 'aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d', TRUE),  -- password: hello
                                                      ('TestUser', 'aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d', FALSE); -- password: hello

-- Insert sample achievements
INSERT INTO achievements (achievement_id, name, description, icon_url, condition_type, condition_value) VALUES
                                                                                                            (1, 'Amateur Author', 'Created your first quiz', '🏆', 'quiz_created', 1),
                                                                                                            (2, 'Prolific Author', 'Created 5 quizzes', '🏆', 'quiz_created', 5),
                                                                                                            (3, 'Prodigious Author', 'Created 10 quizzes', '🏆', 'quiz_created', 10),
                                                                                                            (4, 'Quiz Machine', 'Took 10 quizzes', '⚡', 'quiz_count', 10),
                                                                                                            (5, 'I am the Greatest', 'Achieved the highest score on a quiz', '👑', 'high_score', 1),
                                                                                                            (6, 'Practice Makes Perfect', 'Took a quiz in practice mode', '📚', 'practice_mode', 1),
                                                                                                            (7, 'Perfectionist', 'Scored 100% on any quiz', '🎯', 'perfect_score', 100),
                                                                                                            (8, 'Speed Demon', 'Completed a quiz in under 30 seconds', '⚡', 'quiz_count', 1),
                                                                                                            (9, 'Dedicated Learner', 'Took 25 quizzes', '📖', 'quiz_count', 25),
                                                                                                            (10, 'Quiz Master', 'Took 50 quizzes', '🎓', 'quiz_count', 50);

-- Insert sample quizzes for testing
INSERT INTO quizzes (quiz_id, title, description, creator_name) VALUES
                                                                    (1, 'Geography Quiz', 'Test your knowledge of world geography', 'Admin'),
                                                                    (2, 'Science Quiz', 'Basic science questions for everyone', 'Admin'),
                                                                    (3, 'History Quiz', 'World history trivia', 'TestUser');

-- Insert sample questions
INSERT INTO questions (quiz_id, question_text, question_type, question_order, correct_answers, choices) VALUES
-- Geography Quiz Questions
(1, 'What is the capital of France?', 'multiple_choice', 1, '["Paris"]', '["Paris", "London", "Berlin", "Madrid"]'),
(1, 'Which continent is Brazil in?', 'question_response', 2, '["South America", "South American"]', NULL),
(1, 'What is the largest ocean?', 'multiple_choice', 3, '["Pacific Ocean"]', '["Pacific Ocean", "Atlantic Ocean", "Indian Ocean", "Arctic Ocean"]'),
(1, 'The _______ River is the longest river in the world.', 'fill_blank', 4, '["Nile", "Nile River"]', NULL),

-- Science Quiz Questions
(2, 'What is H2O?', 'question_response', 1, '["Water", "water"]', NULL),
(2, 'How many legs does a spider have?', 'multiple_choice', 2, '["8"]', '["6", "8", "10", "12"]'),
(2, 'What gas do plants absorb from the atmosphere?', 'question_response', 3, '["Carbon Dioxide", "CO2", "carbon dioxide"]', NULL),

-- History Quiz Questions
(3, 'In which year did World War II end?', 'multiple_choice', 1, '["1945"]', '["1944", "1945", "1946", "1947"]'),
(3, 'Who was the first person to walk on the moon?', 'question_response', 2, '["Neil Armstrong", "Armstrong"]', NULL);

-- Insert sample quiz attempts for testing
INSERT INTO quiz_attempts (user_name, quiz_id, score, total_questions, time_taken, answers, correct_answers, is_practice_mode) VALUES
                                                                                                                                   ('TestUser', 1, 3, 4, 120, '["Paris", "South America", "Atlantic Ocean", "Nile"]', '["Paris", "South America", "Pacific Ocean", "Nile"]', FALSE),
                                                                                                                                   ('TestUser', 2, 2, 3, 90, '["Water", "8", "Oxygen"]', '["Water", "8", "Carbon Dioxide"]', FALSE),
                                                                                                                                   ('TestUser', 1, 4, 4, 95, '["Paris", "South America", "Pacific Ocean", "Nile"]', '["Paris", "South America", "Pacific Ocean", "Nile"]', TRUE);

-- =====================================================
-- HELPFUL VIEWS FOR STATISTICS (Person 3)
-- =====================================================

-- Quiz statistics view
CREATE OR REPLACE VIEW quiz_statistics AS
SELECT
    q.quiz_id,
    q.title,
    q.creator_name,
    COUNT(qa.attempt_id) as total_attempts,
    COUNT(DISTINCT qa.user_name) as unique_users,
    AVG(qa.score / qa.total_questions * 100) as average_score,
    MAX(qa.score / qa.total_questions * 100) as highest_score,
    MIN(qa.time_taken) as fastest_time,
    AVG(qa.time_taken) as average_time
FROM quizzes q
         LEFT JOIN quiz_attempts qa ON q.quiz_id = qa.quiz_id
WHERE qa.is_practice_mode = FALSE OR qa.is_practice_mode IS NULL
GROUP BY q.quiz_id, q.title, q.creator_name;

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

-- =====================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================

CREATE INDEX idx_quiz_attempts_user_date ON quiz_attempts(user_name, attempt_date DESC);
CREATE INDEX idx_quiz_attempts_quiz_score ON quiz_attempts(quiz_id, score DESC);
CREATE INDEX idx_user_achievements_user ON user_achievements(user_name);
CREATE INDEX idx_achievements_condition ON achievements(condition_type, condition_value);
CREATE INDEX idx_questions_quiz ON questions(quiz_id, question_order);

-- Show success message
SELECT 'QuizWebsite database setup completed successfully!' as message;