CREATE DATABASE IF NOT EXISTS QuizWebsite;

USE QuizWebsite;

DROP TABLE IF EXISTS users;

CREATE TABLE users (
    login VARCHAR(100) PRIMARY KEY,
    hashedpassword VARCHAR(255) NOT NULL,
    isadmin boolean NOT NULL
);

