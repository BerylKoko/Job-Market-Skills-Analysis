-- Job Market & Skills Analysis
-- Example SQL analyses for the relational version of the project.

WITH classified AS (
    SELECT
        job_id,
        title,
        COALESCE(NULLIF(formatted_experience_level, ''), 'Missing') AS experience_level,
        normalized_salary,
        CASE
            WHEN LOWER(title) LIKE '%product manager%' THEN 'Product management'
            WHEN LOWER(title) LIKE '%product analyst%' THEN 'Product analyst'
            WHEN LOWER(title) LIKE '%business intelligence%' OR LOWER(title) LIKE '%bi analyst%'
                THEN 'Business intelligence'
            WHEN LOWER(title) LIKE '%business analyst%' OR LOWER(title) LIKE '%business systems analyst%'
                THEN 'Business analyst'
            WHEN LOWER(title) LIKE '%data analyst%' OR LOWER(title) LIKE '%analytics analyst%'
                THEN 'Data analyst'
        END AS role_family
    FROM job_postings
)
SELECT role_family, COUNT(*) AS postings
FROM classified
WHERE role_family IS NOT NULL
GROUP BY role_family
ORDER BY postings DESC;

WITH classified AS (
    SELECT
        job_id,
        COALESCE(NULLIF(formatted_experience_level, ''), 'Missing') AS experience_level,
        CASE
            WHEN LOWER(title) LIKE '%product manager%' THEN 'Product management'
            WHEN LOWER(title) LIKE '%product analyst%' THEN 'Product analyst'
            WHEN LOWER(title) LIKE '%business intelligence%' OR LOWER(title) LIKE '%bi analyst%'
                THEN 'Business intelligence'
            WHEN LOWER(title) LIKE '%business analyst%' OR LOWER(title) LIKE '%business systems analyst%'
                THEN 'Business analyst'
            WHEN LOWER(title) LIKE '%data analyst%' OR LOWER(title) LIKE '%analytics analyst%'
                THEN 'Data analyst'
        END AS role_family
    FROM job_postings
)
SELECT role_family, experience_level, COUNT(*) AS postings
FROM classified
WHERE role_family IS NOT NULL
GROUP BY role_family, experience_level
ORDER BY role_family, postings DESC;

WITH classified AS (
    SELECT
        job_id,
        normalized_salary,
        CASE
            WHEN LOWER(title) LIKE '%product manager%' THEN 'Product management'
            WHEN LOWER(title) LIKE '%product analyst%' THEN 'Product analyst'
            WHEN LOWER(title) LIKE '%business intelligence%' OR LOWER(title) LIKE '%bi analyst%'
                THEN 'Business intelligence'
            WHEN LOWER(title) LIKE '%business analyst%' OR LOWER(title) LIKE '%business systems analyst%'
                THEN 'Business analyst'
            WHEN LOWER(title) LIKE '%data analyst%' OR LOWER(title) LIKE '%analytics analyst%'
                THEN 'Data analyst'
        END AS role_family
    FROM job_postings
)
SELECT
    role_family,
    COUNT(normalized_salary) AS salary_records,
    AVG(normalized_salary) AS mean_normalized_salary
FROM classified
WHERE role_family IS NOT NULL
  AND normalized_salary > 0
GROUP BY role_family
ORDER BY mean_normalized_salary DESC;

WITH classified AS (
    SELECT
        job_id,
        CASE
            WHEN LOWER(title) LIKE '%product manager%' THEN 'Product management'
            WHEN LOWER(title) LIKE '%product analyst%' THEN 'Product analyst'
            WHEN LOWER(title) LIKE '%business intelligence%' OR LOWER(title) LIKE '%bi analyst%'
                THEN 'Business intelligence'
            WHEN LOWER(title) LIKE '%business analyst%' OR LOWER(title) LIKE '%business systems analyst%'
                THEN 'Business analyst'
            WHEN LOWER(title) LIKE '%data analyst%' OR LOWER(title) LIKE '%analytics analyst%'
                THEN 'Data analyst'
        END AS role_family
    FROM job_postings
)
SELECT
    c.role_family,
    s.skill_name,
    COUNT(*) AS tagged_postings
FROM classified c
JOIN job_skills js ON c.job_id = js.job_id
JOIN skills s ON js.skill_abr = s.skill_abr
WHERE c.role_family IS NOT NULL
GROUP BY c.role_family, s.skill_name
ORDER BY c.role_family, tagged_postings DESC;
