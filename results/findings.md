# Findings

This analysis uses the **14,680 valid postings currently committed in this repository**. It is a snapshot of the larger LinkedIn Job Postings 2023–2024 source dataset.

## 1. Data / BI has the strongest entry-level signal in this snapshot

Among postings with a stated experience level:

| Role family | Entry-level postings | Experience-labeled postings | Entry-level share |
| --- | ---: | ---: | ---: |
| Data / BI | 20 | 44 | **45.5%** |
| Software Engineering | 19 | 157 | **12.1%** |
| Business Analysis | 5 | 49 | **10.2%** |
| Product | 5 | 63 | **7.9%** |

**Interpretation:** the Data / BI subset is much more likely to carry an explicit “Entry level” label than the other three role families.

**Limitation:** stated LinkedIn experience level is not the same thing as years-of-experience requirements inside the job description.

## 2. Product and Software Engineering have the highest median salary in the salary-reporting subset

After retaining normalized salaries between $20,000 and $500,000:

| Role family | Salary records | Median normalized salary |
| --- | ---: | ---: |
| Product | 29 | **$152,625** |
| Software Engineering | 49 | **$145,600** |
| Business Analysis | 23 | **$90,000** |
| Data / BI | 16 | **$86,320** |

**Interpretation:** the Product and Software Engineering postings that disclose usable salary data sit at substantially higher medians in this sample.

**Limitation:** salary coverage is sparse, so these figures should not be generalized to all postings.

## 3. The skill profile changes meaningfully by role family

Keyword mentions in job descriptions:

| Role family | SQL | Python | Excel | Power BI | Tableau | AWS | Azure |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Product | 14.1% | 10.3% | 6.4% | 1.3% | 10.3% | 5.1% | 6.4% |
| Data / BI | **38.6%** | 15.8% | **38.6%** | **17.5%** | 10.5% | 5.3% | 1.8% |
| Business Analysis | 26.0% | 6.8% | 24.7% | 9.6% | 6.8% | 2.7% | 2.7% |
| Software Engineering | 24.7% | **33.3%** | 2.7% | 1.4% | 2.7% | **39.3%** | **26.0%** |

**Interpretation:** Data / BI leans heavily toward SQL and Excel, while Software Engineering shows a much stronger cloud + Python profile.

**Limitation:** these are description mentions, not a guarantee that every mention is a hard requirement.

## 4. Software Engineering is the most remote-friendly of the four groups

| Role family | Remote-allowed share |
| --- | ---: |
| Software Engineering | **36.5%** |
| Data / BI | **21.1%** |
| Product | **14.1%** |
| Business Analysis | **13.7%** |

The field is taken directly from the dataset's `remote_allowed` indicator.

## What I would investigate next

A larger follow-up could parse explicit years-of-experience requirements from job descriptions and test whether roles labeled “Entry level” still ask for 2–5 years of prior experience. That question is interesting, but this compact portfolio version does not claim to answer it without doing that extraction first.
