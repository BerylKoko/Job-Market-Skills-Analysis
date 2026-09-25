-- Job Market & Skills Analysis
-- Requires schema.sql to be loaded first.

-- 1. Role-family volume.
SELECT role_family, COUNT(*) AS postings
FROM target_roles
GROUP BY role_family
ORDER BY postings DESC;

-- 2. How much of each role family is explicitly labeled entry level?
WITH experience AS (
    SELECT
        role_family,
        COUNT(*) FILTER (
            WHERE formatted_experience_level IS NOT NULL
              AND trim(formatted_experience_level) <> ''
        ) AS experience_labeled,
        COUNT(*) FILTER (
            WHERE formatted_experience_level = 'Entry level'
        ) AS entry_level
    FROM target_roles
    GROUP BY role_family
)
SELECT
    role_family,
    experience_labeled,
    entry_level,
    ROUND(100.0 * entry_level / NULLIF(experience_labeled, 0), 1)
        AS entry_level_pct
FROM experience
ORDER BY entry_level_pct DESC;

-- 3. Median normalized salary by role family.
-- Restrict to a broad plausible annual range to reduce obvious outliers.
SELECT
    role_family,
    COUNT(normalized_salary) AS salary_records,
    ROUND(MEDIAN(normalized_salary), 0) AS median_normalized_salary
FROM target_roles
WHERE normalized_salary BETWEEN 20000 AND 500000
GROUP BY role_family
ORDER BY median_normalized_salary DESC;

-- 4. Remote-allowed share.
SELECT
    role_family,
    COUNT(*) AS postings,
    COUNT(*) FILTER (WHERE TRY_CAST(remote_allowed AS DOUBLE) = 1) AS remote_allowed,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE TRY_CAST(remote_allowed AS DOUBLE) = 1)
        / COUNT(*),
        1
    ) AS remote_pct
FROM target_roles
GROUP BY role_family
ORDER BY remote_pct DESC;

-- 5. Granular skill mentions in descriptions.
WITH skill_flags AS (
    SELECT
        role_family,
        regexp_matches(lower(description), '\\bsql\\b') AS sql,
        regexp_matches(lower(description), '\\bpython\\b') AS python,
        regexp_matches(lower(description), '\\bexcel\\b') AS excel,
        regexp_matches(lower(description), '\\btableau\\b') AS tableau,
        regexp_matches(lower(description), '\\bpower[ ]*bi\\b') AS power_bi,
        regexp_matches(lower(description), '\\baws\\b|amazon web services') AS aws,
        regexp_matches(lower(description), '\\bazure\\b') AS azure
    FROM target_roles
)
SELECT
    role_family,
    ROUND(100.0 * SUM(sql::INT) / COUNT(*), 1) AS sql_pct,
    ROUND(100.0 * SUM(python::INT) / COUNT(*), 1) AS python_pct,
    ROUND(100.0 * SUM(excel::INT) / COUNT(*), 1) AS excel_pct,
    ROUND(100.0 * SUM(tableau::INT) / COUNT(*), 1) AS tableau_pct,
    ROUND(100.0 * SUM(power_bi::INT) / COUNT(*), 1) AS power_bi_pct,
    ROUND(100.0 * SUM(aws::INT) / COUNT(*), 1) AS aws_pct,
    ROUND(100.0 * SUM(azure::INT) / COUNT(*), 1) AS azure_pct
FROM skill_flags
GROUP BY role_family
ORDER BY role_family;

-- 6. Top locations by role family.
WITH ranked AS (
    SELECT
        role_family,
        location,
        COUNT(*) AS postings,
        ROW_NUMBER() OVER (
            PARTITION BY role_family
            ORDER BY COUNT(*) DESC
        ) AS rank
    FROM target_roles
    WHERE location IS NOT NULL AND trim(location) <> ''
    GROUP BY role_family, location
)
SELECT role_family, location, postings
FROM ranked
WHERE rank <= 5
ORDER BY role_family, rank;
