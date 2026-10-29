-- SkillSwap database schema (MySQL 8+)
-- Run this file in MySQL Workbench before starting the application.
CREATE DATABASE IF NOT EXISTS skillswap_db;
USE skillswap_db;

CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(190) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    bio TEXT,
    location VARCHAR(150),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS skills (
    id INT PRIMARY KEY AUTO_INCREMENT,
    skill_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE IF NOT EXISTS user_skills (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    skill_id INT NOT NULL,
    skill_type ENUM('OFFER', 'LEARN') NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_skills_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_user_skills_skill FOREIGN KEY (skill_id) REFERENCES skills(id) ON DELETE CASCADE,
    CONSTRAINT uq_user_skill_type UNIQUE (user_id, skill_id, skill_type)
);

CREATE TABLE IF NOT EXISTS skill_requests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    requester_id INT NOT NULL,
    receiver_id INT NOT NULL,
    skill_id INT NOT NULL,
    message TEXT,
    status ENUM('PENDING', 'ACCEPTED', 'REJECTED') NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_requests_requester FOREIGN KEY (requester_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_requests_receiver FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_requests_skill FOREIGN KEY (skill_id) REFERENCES skills(id),
    CONSTRAINT chk_request_different_users CHECK (requester_id <> receiver_id)
);

CREATE TABLE IF NOT EXISTS exchanges (
    id INT PRIMARY KEY AUTO_INCREMENT,
    request_id INT NOT NULL UNIQUE,
    user1_id INT NOT NULL,
    user2_id INT NOT NULL,
    skill1_id INT NOT NULL,
    skill2_id INT NULL,
    status ENUM('ACTIVE', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'ACTIVE',
    started_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL,
    CONSTRAINT fk_exchanges_request FOREIGN KEY (request_id) REFERENCES skill_requests(id),
    CONSTRAINT fk_exchanges_user1 FOREIGN KEY (user1_id) REFERENCES users(id),
    CONSTRAINT fk_exchanges_user2 FOREIGN KEY (user2_id) REFERENCES users(id),
    CONSTRAINT fk_exchanges_skill1 FOREIGN KEY (skill1_id) REFERENCES skills(id),
    CONSTRAINT fk_exchanges_skill2 FOREIGN KEY (skill2_id) REFERENCES skills(id)
);

CREATE TABLE IF NOT EXISTS reviews (
    id INT PRIMARY KEY AUTO_INCREMENT,
    exchange_id INT NOT NULL,
    reviewer_id INT NOT NULL,
    reviewed_user_id INT NOT NULL,
    rating TINYINT NOT NULL,
    comment TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_reviews_exchange FOREIGN KEY (exchange_id) REFERENCES exchanges(id) ON DELETE CASCADE,
    CONSTRAINT fk_reviews_reviewer FOREIGN KEY (reviewer_id) REFERENCES users(id),
    CONSTRAINT fk_reviews_reviewed FOREIGN KEY (reviewed_user_id) REFERENCES users(id),
    CONSTRAINT uq_review_per_user_exchange UNIQUE (exchange_id, reviewer_id),
    CONSTRAINT chk_rating CHECK (rating BETWEEN 1 AND 5),
    CONSTRAINT chk_review_different_users CHECK (reviewer_id <> reviewed_user_id)
);

-- Starter skills; safe to run more than once.
INSERT IGNORE INTO skills (skill_name, description) VALUES
('Java', 'Java programming and object-oriented programming'),
('Python', 'Python programming'),
('Web Development', 'HTML, CSS, JavaScript and web applications'),
('SQL', 'Relational databases and SQL'),
('Communication', 'Presentation and communication skills'),
('Graphic Design', 'Visual design and design tools');
