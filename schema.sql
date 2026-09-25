-- DuckDB schema for the repository CSV snapshot.
-- Run from the repository root:
--   duckdb job_market.duckdb < schema.sql

CREATE OR REPLACE VIEW postings AS
SELECT *
FROM read_csv_auto('postings.csv', header = true, sample_size = -1);

CREATE OR REPLACE VIEW companies AS
SELECT *
FROM read_csv_auto('companies.csv', header = true, sample_size = -1);

CREATE OR REPLACE VIEW salaries AS
SELECT *
FROM read_csv_auto('salaries.csv', header = true, sample_size = -1);

CREATE OR REPLACE VIEW job_skills AS
SELECT *
FROM read_csv_auto('job_skills.csv', header = true, sample_size = -1);

CREATE OR REPLACE VIEW skills AS
SELECT *
FROM read_csv_auto('skills.csv', header = true, sample_size = -1);

CREATE OR REPLACE VIEW job_industries AS
SELECT *
FROM read_csv_auto('job_industries.csv', header = true, sample_size = -1);

CREATE OR REPLACE VIEW industries AS
SELECT *
FROM read_csv_auto('industries.csv', header = true, sample_size = -1);

CREATE OR REPLACE VIEW target_roles AS
SELECT
    *,
    CASE
        WHEN regexp_matches(lower(title),
             '(associate product manager|product manager|product management|product analyst|product operations|product owner)')
            THEN 'Product'
        WHEN regexp_matches(lower(title),
             '(data analyst|analytics analyst|business intelligence analyst|bi analyst|reporting analyst)')
            THEN 'Data / BI'
        WHEN regexp_matches(lower(title),
             '(business analyst|business systems analyst|systems analyst|technical business analyst)')
            THEN 'Business Analysis'
        WHEN regexp_matches(lower(title),
             '(software engineer|software developer|frontend|front-end|backend|back-end|full stack|full-stack)')
            THEN 'Software Engineering'
        ELSE NULL
    END AS role_family
FROM postings
WHERE role_family IS NOT NULL;
