# Job Market & Skills Analysis

An exploratory analysis of analyst, product, and business-intelligence job postings, presented in three layers:

- **`index.html`** — executive-style visual presentation
- **`JobMarketAnalysis.ipynb`** — transparent, reproducible analysis
- **`README.md`** — concise methodology and findings summary

## Research question

**What do analyst, product, and business-intelligence job postings actually ask for, and how do role family, experience level, salary, skills, and industry differ across them?**

The project follows the same analysis structure I use in coursework:

**question → data overview → cleaning → joins → exploratory analysis → visualization → interpretation → limitations**

## Dataset

The repository contains **14,681 job postings** plus related company, salary, skill, and industry tables. A conservative title classifier identifies **188 postings** across five target role families:

- Business Analyst — 67
- Product Management — 59
- Data Analyst — 45
- Business Intelligence — 15
- Product Analyst — 2

The analysis is exploratory. The data is a snapshot, not a census of the labor market.

## Data model and joins

The source data is relational rather than one flat table.

`postings.csv` is the main job-level table. Two bridge-table relationships are used in the notebook:

```text
postings.job_id
      ↓
job_skills.job_id ── skill_abr ──→ skills.skill_abr
```

and

```text
postings.job_id
      ↓
job_industries.job_id ── industry_id ──→ industries.industry_id
```

In pandas, the pattern is:

```python
job_skill_names = job_skills.merge(
    skills,
    on="skill_abr",
    how="left",
)

role_skills = target[
    ["job_id", "role_family"]
].merge(
    job_skill_names,
    on="job_id",
    how="left",
)
```

The industry tables follow the same two-step join.

## Cleaning decisions

The notebook documents the cleaning process directly. The main choices were:

- load only posting fields needed for the research question
- normalize title text before classification
- group only clear title matches into role families
- keep ambiguous titles out rather than force-classifying them
- retain missing experience labels as `Missing`
- exclude unusable salary values only from salary-specific calculations
- attach broad skill and industry categories through relational joins
- separately scan job-description text for literal tools such as SQL, Python, Tableau, and Power BI
- keep sample size visible alongside salary summaries

## Main findings

### Role mix

Business Analyst and Product Management are the largest matched groups. Product Analyst has only two captured postings, so it is not treated as a stable comparison group.

### Seniority

Only **28 of 188 postings (14.9%)** are explicitly labeled Entry level.

The contrast by role is large:

- Data Analyst — **42.2%** Entry level
- Business Analyst — **7.5%**
- Product Management — **6.8%**

Across the complete target sample, **43.6%** are labeled Mid-Senior and **25.5%** have no experience label.

### Compensation

Among postings with usable normalized salary values:

- Product Management — **$174,300 median** (`n=23`)
- Business Intelligence — **$120,640** (`n=6`)
- Business Analyst — **$91,957** (`n=19`)
- Data Analyst — **$81,640** (`n=10`)

These are descriptive results, not a causal role ranking. The role families contain different seniority mixes and salary coverage is incomplete. The notebook therefore uses a **box plot** to show distribution rather than relying only on median bars.

### Technical signals

Across the 188 target descriptions:

- SQL — **29.3%**
- Excel — **22.9%**
- Python — **12.2%**
- Tableau — **11.7%**
- Power BI — **10.6%**

SQL also crosses role boundaries: it appears in **37.8% of Data Analyst**, **66.7% of Business Intelligence**, and **18.6% of Product Management** descriptions.

The notebook visualizes tools with a **role × tool heatmap** so the comparison is not reduced to another ranked bar chart.

## Visual presentation

The project includes a standalone presentation page in `index.html`. It is intentionally styled more like an analyst presenting findings to executives than a traditional portfolio case study:

- charcoal / near-black background
- large headline metrics
- restrained mint accent
- annotations next to conclusions
- role ranking, seniority composition, salary dot plot, and skill signals
- methodology and relational joins presented visually

The notebook remains the analysis layer underneath the presentation.

## Notebook visualization choices

Different questions use different chart forms:

- role volume → horizontal bar ranking
- experience mix → 100% stacked bar
- compensation → box plot
- tool comparison → heatmap
- industry concentration → lollipop chart

The goal is to match the chart to the analytical question rather than repeat one visual form.

## Repository structure

```text
Job-Market-Skills-Analysis/
├── index.html
├── styles.css
├── dashboard.js
├── JobMarketAnalysis.ipynb
├── postings.csv
├── companies.csv
├── job_skills.csv
├── skills.csv
├── salaries.csv
├── job_industries.csv
├── industries.csv
├── schema.sql
├── analysis.sql
├── scripts/
│   └── clean_data.py
├── results/
│   ├── findings.md
│   └── charts/
└── README.md
```

## Limitations

- The dataset is a snapshot rather than the full current labor market.
- Title classification is rule-based and intentionally conservative.
- Experience labels are missing for part of the target sample.
- Salary coverage is incomplete and depends on the source dataset's normalization.
- Literal tool matching misses synonyms and implied requirements.
- Jobs can map to multiple skills and industries, so joined-table counts are associations rather than mutually exclusive categories.
- Product Analyst is too small for stable statistical comparison.
- The analysis is descriptive and does not establish causation.
