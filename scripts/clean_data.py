"""Light cleaning helpers for the LinkedIn job-posting snapshot."""

from pathlib import Path

import pandas as pd


ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "postings.csv"
OUTPUT = ROOT / "data" / "analysis_jobs.csv"


def classify_role(title: str) -> str | None:
    title = str(title).lower()

    product_terms = (
        "product manager",
        "product management",
        "product analyst",
        "product operations",
        "product owner",
    )
    data_terms = (
        "data analyst",
        "analytics analyst",
        "business intelligence analyst",
        "bi analyst",
        "reporting analyst",
    )
    business_terms = (
        "business analyst",
        "business systems analyst",
        "technical business analyst",
        "systems analyst",
    )
    software_terms = (
        "software engineer",
        "software developer",
        "frontend",
        "front-end",
        "backend",
        "back-end",
        "full stack",
        "full-stack",
    )

    if any(term in title for term in product_terms):
        return "Product"
    if any(term in title for term in data_terms):
        return "Data / BI"
    if any(term in title for term in business_terms):
        return "Business Analysis"
    if any(term in title for term in software_terms):
        return "Software Engineering"
    return None


def main() -> None:
    df = pd.read_csv(RAW, low_memory=False)
    df = df.drop_duplicates(subset="job_id").copy()

    df["role_family"] = df["title"].map(classify_role)
    df = df[df["role_family"].notna()].copy()

    df["normalized_salary"] = pd.to_numeric(
        df["normalized_salary"], errors="coerce"
    )
    df["salary_valid"] = df["normalized_salary"].between(20_000, 500_000)

    df["remote_allowed"] = (
        pd.to_numeric(df["remote_allowed"], errors="coerce")
        .fillna(0)
        .eq(1)
    )

    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    df.to_csv(OUTPUT, index=False)

    print(f"Saved {len(df):,} target-role postings to {OUTPUT}")


if __name__ == "__main__":
    main()
