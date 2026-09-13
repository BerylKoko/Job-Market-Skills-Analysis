# Job Market & Skills Analysis

A compact SQL and data-modeling project focused on practical questions about analyst, product, and technical roles.

## Project goal

Build a relational dataset of job postings, companies, locations, industries, and skills, then use SQL to answer decision-oriented questions about the job market.

The point of the project is to demonstrate:

- relational data modeling
- data cleaning
- joins
- CTEs
- aggregations
- window functions
- `CASE` statements
- useful metrics
- turning query results into clear conclusions

This is an analysis project, not a frontend project. Keep it focused.

## Core questions

Start with these questions and keep only the ones the data can support well:

1. Which skills are most common in $90k+ analyst, product, and technical roles?
2. Which skills tend to appear together?
3. Which job titles offer the highest pay with the lowest experience requirements?
4. How do requirements differ across tech, finance, healthcare, consulting, and other industries?
5. Which cities have the best combination of salary and number of openings?
6. Does requiring Python, SQL, or BI tools correlate with higher salary bands?
7. Which skills give candidates the broadest access across multiple role families?

## Suggested data model

A useful starting point:

- `industries`
- `companies`
- `locations`
- `job_postings`
- `skills`
- `job_skills`

Possible relationships:

- one industry -> many companies
- one company -> many job postings
- one location -> many job postings
- many job postings <-> many skills through `job_skills`

The final schema should come from the data you actually choose. Do not force this exact structure if the dataset suggests a better one.

## Suggested workflow

### 1. Choose a dataset

Aim for roughly 500-2,000 job postings if practical.

Useful raw fields may include:

- job title
- company
- industry
- city/state
- minimum and maximum salary
- years of experience
- job description
- listed skills
- employment type
- posting date

### 2. Inspect and clean the data

Use `scripts/clean_data.py` for cleaning that is easier in Python.

Potential tasks:

- standardize job titles
- clean salary strings
- split location fields
- normalize company names
- standardize industries
- extract or standardize skills
- handle missing values

Document meaningful cleaning decisions rather than silently changing the data.

### 3. Design the relational model

Use `schema.sql`.

Think through:

- primary keys
- foreign keys
- which values deserve their own tables
- many-to-many relationships
- avoiding repeated company, location, and skill text

Add an ER diagram to `diagrams/` when the schema is stable.

### 4. Load the cleaned data

Load the cleaned tables into the SQL database you choose. Document the database and import method in this README once decided.

### 5. Answer decision-oriented questions

Use `analysis.sql`.

Use SQL features when they help answer a real question, including:

- multi-table joins
- CTEs
- `GROUP BY` and aggregations
- `CASE`
- window functions
- ranking
- percentages and rates
- role, location, salary, and industry segmentation

Do not add techniques merely to check a box.

### 6. Turn results into conclusions

For each important result, record:

- the question
- the metric or method
- the result
- what the result suggests
- an important limitation or caveat

Save the strongest conclusions in `results/findings.md` and useful charts in `results/charts/`.

## Target final deliverables

A finished version should ideally contain:

- a clear relational schema
- an ER diagram
- cleaned data or reproducible cleaning steps
- about 8-12 strong SQL analyses
- 3-5 charts or tables
- a concise findings summary

## How the same project can be presented differently

### Analyst / BI framing

Emphasize SQL, relational modeling, cleaning, metrics, joins, CTEs, window functions, and findings.

### Product / PM framing

Emphasize choosing useful questions, defining metrics, comparing segments, interpreting tradeoffs, and turning data into recommendations.

Same project, different presentation.

## Repository structure

```text
Job-Market-Skills-Analysis/
├── data/
│   └── README.md
├── diagrams/
│   └── README.md
├── results/
│   ├── charts/
│   └── findings.md
├── scripts/
│   └── clean_data.py
├── analysis.sql
├── schema.sql
├── requirements.txt
└── README.md
```

## Status

Project skeleton created. Data source and final schema are intentionally still open decisions.
