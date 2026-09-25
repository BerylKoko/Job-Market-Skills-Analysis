-- Job Market & Skills Analysis
-- Lightweight relational schema matching the CSV structure used in this project.

CREATE TABLE job_postings (
    job_id BIGINT PRIMARY KEY,
    company_name TEXT,
    title TEXT,
    description TEXT,
    location TEXT,
    formatted_experience_level TEXT,
    normalized_salary REAL,
    remote_allowed INTEGER,
    formatted_work_type TEXT
);

CREATE TABLE skills (
    skill_abr TEXT PRIMARY KEY,
    skill_name TEXT NOT NULL
);

CREATE TABLE job_skills (
    job_id BIGINT NOT NULL,
    skill_abr TEXT NOT NULL,
    PRIMARY KEY (job_id, skill_abr),
    FOREIGN KEY (job_id) REFERENCES job_postings(job_id),
    FOREIGN KEY (skill_abr) REFERENCES skills(skill_abr)
);

CREATE TABLE industries (
    industry_id INTEGER PRIMARY KEY,
    industry_name TEXT NOT NULL
);

CREATE TABLE job_industries (
    job_id BIGINT NOT NULL,
    industry_id INTEGER NOT NULL,
    PRIMARY KEY (job_id, industry_id),
    FOREIGN KEY (job_id) REFERENCES job_postings(job_id),
    FOREIGN KEY (industry_id) REFERENCES industries(industry_id)
);
