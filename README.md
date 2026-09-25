# Job Market & Skills Analysis

A compact analysis of LinkedIn job postings focused on one practical question:

> **Which early-career paths look most accessible across product, data/BI, business analysis, and software engineering — and what skills and pay patterns separate them?**

This project uses the LinkedIn Job Postings 2023–2024 dataset published on Kaggle by Arsh Koneru. The CSV snapshot committed in this repository contains **14,680 valid postings** from the larger source dataset.

## Why I built this

Job titles like “entry level,” “analyst,” and “product” can hide very different expectations. I wanted to compare adjacent career paths using the same source data rather than relying on job-search anecdotes.

I focused on four role families:

- Product
- Data / BI
- Business Analysis
- Software Engineering

The analysis looks at role volume, stated experience level, normalized salary, remote availability, location, and recurring technical keywords in job descriptions.

## Key findings

### 1. Data / BI had the clearest entry-level signal

Among postings with a stated experience level, **45.5% of Data / BI roles were labeled Entry level**. The equivalent shares were **12.1% for Software Engineering, 10.2% for Business Analysis, and 7.9% for Product**.

This does not mean Data / BI is “easy” to enter. It means the dataset labeled a much larger share of those postings as entry level.

### 2. Product paid highly in the salary-reporting subset, but entry-level volume was thin

The median normalized salary among valid salary records was:

- **Product: $152,625**
- **Software Engineering: $145,600**
- **Business Analysis: $90,000**
- **Data / BI: $86,320**

Salary coverage is incomplete, so these numbers describe the salary-reporting subset rather than every posting.

### 3. Data / BI descriptions emphasized SQL and Excel

Within the role-family subset, keyword matching on job descriptions found:

- **Data / BI:** SQL 38.6%, Excel 38.6%, Power BI 17.5%, Python 15.8%
- **Business Analysis:** SQL 26.0%, Excel 24.7%
- **Software Engineering:** AWS 39.3%, Python 33.3%, Azure 26.0%, SQL 24.7%
- **Product:** SQL 14.1%, Python 10.3%, Tableau 10.3%

The dataset's provided skill mapping contains broad functional categories, so this project extracts granular tools such as SQL and Python directly from posting descriptions.

### 4. Remote availability varied substantially by role family

The share of postings marked remote-allowed was:

- **Software Engineering: 36.5%**
- **Data / BI: 21.1%**
- **Product: 14.1%**
- **Business Analysis: 13.7%**

## Methods

### Role-family classification

Titles are grouped with transparent keyword rules. For example:

- Product: Product Manager, Product Analyst, Product Operations, Product Owner
- Data / BI: Data Analyst, Analytics Analyst, BI Analyst, Reporting Analyst
- Business Analysis: Business Analyst, Business Systems Analyst, Systems Analyst
- Software Engineering: Software Engineer/Developer, Frontend, Backend, Full Stack

The rules intentionally favor precision over capturing every possible adjacent title.

### Salary handling

I use `normalized_salary` and retain values between **$20,000 and $500,000** for salary summaries. This avoids obvious outliers while preserving a broad range of legitimate annual compensation.

### Skill extraction

The repository includes LinkedIn's broad skill-category mappings, but those categories do not distinguish tools like SQL, Python, Excel, Tableau, or Power BI. For this analysis, those skills are identified with case-insensitive keyword matching in `description`.

## Reproduce the analysis

Install dependencies:

```bash
pip install -r requirements.txt
```

Run the Python analysis:

```bash
python scripts/analyze_jobs.py
```

Or run the SQL workflow with DuckDB:

```bash
duckdb job_market.duckdb < schema.sql
duckdb job_market.duckdb < analysis.sql
```

## Repository structure

```text
Job-Market-Skills-Analysis/
├── postings.csv
├── companies.csv
├── salaries.csv
├── job_skills.csv
├── skills.csv
├── job_industries.csv
├── industries.csv
├── schema.sql
├── analysis.sql
├── scripts/
│   ├── clean_data.py
│   └── analyze_jobs.py
├── results/
│   ├── findings.md
│   ├── summary.csv
│   └── charts/
│       ├── entry_level_share.svg
│       ├── median_salary.svg
│       └── skill_demand.svg
└── README.md
```

## Limitations

- This repository contains a **14,680-posting snapshot**, not the full source dataset.
- Experience level and salary are missing for many postings.
- Role families are rule-based and do not capture every adjacent title.
- Skill frequencies are keyword matches in descriptions; they measure mentions, not proficiency requirements.
- This is a historical 2023–2024 LinkedIn snapshot, not a description of the 2026 job market.

## Data source

LinkedIn Job Postings 2023–2024, Arsh Koneru (Kaggle): `arshkon/linkedin-job-postings`.
