CREATE DATABASE IF NOT EXISTS QuizWebsite;

USE QuizWebsite;

DROP TABLE IF EXISTS users;

CREATE TABLE users (
    login CHAR(64),
    hashedpassword CHAR(64),
    isadmin boolean
);

