"""Reproduce the headline findings and charts for the portfolio project."""

from pathlib import Path
import re

import matplotlib.pyplot as plt
import pandas as pd


ROOT = Path(__file__).resolve().parents[1]
POSTINGS = ROOT / "postings.csv"
RESULTS = ROOT / "results"
CHARTS = RESULTS / "charts"

ROLE_PATTERNS = {
    "Product": r"product manager|product management|product analyst|product operations|product owner",
    "Data / BI": r"data analyst|analytics analyst|business intelligence analyst|\bbi analyst\b|reporting analyst",
    "Business Analysis": r"business analyst|business systems analyst|technical business analyst|systems analyst",
    "Software Engineering": r"software engineer|software developer|frontend|front-end|backend|back-end|full stack|full-stack",
}

SKILL_PATTERNS = {
    "SQL": r"\bsql\b",
    "Python": r"\bpython\b",
    "Excel": r"\bexcel\b",
    "Tableau": r"\btableau\b",
    "Power BI": r"\bpower\s*bi\b",
    "AWS": r"\baws\b|amazon web services",
    "Azure": r"\bazure\b",
}


def classify_title(title: str) -> str | None:
    title = str(title).lower()
    for family, pattern in ROLE_PATTERNS.items():
        if re.search(pattern, title):
            return family
    return None


def main() -> None:
    df = pd.read_csv(POSTINGS, low_memory=False)
    df = df.drop_duplicates(subset="job_id").copy()
    df["role_family"] = df["title"].map(classify_title)
    df = df[df["role_family"].notna()].copy()

    df["normalized_salary"] = pd.to_numeric(
        df["normalized_salary"], errors="coerce"
    )
    df["remote_flag"] = (
        pd.to_numeric(df["remote_allowed"], errors="coerce")
        .fillna(0)
        .eq(1)
    )

    rows = []

    for family, group in df.groupby("role_family"):
        known_exp = group["formatted_experience_level"].notna()
        entry = group["formatted_experience_level"].eq("Entry level")
        valid_salary = group["normalized_salary"].between(20_000, 500_000)

        row = {
            "role_family": family,
            "postings": len(group),
            "experience_labeled": int(known_exp.sum()),
            "entry_level_postings": int(entry.sum()),
            "entry_level_pct": round(
                100 * entry.sum() / known_exp.sum(), 1
            ) if known_exp.sum() else None,
            "remote_pct": round(100 * group["remote_flag"].mean(), 1),
            "salary_records": int(valid_salary.sum()),
            "median_salary": round(
                group.loc[valid_salary, "normalized_salary"].median(), 0
            ),
        }

        descriptions = group["description"].fillna("").str.lower()
        for skill, pattern in SKILL_PATTERNS.items():
            row[f"{skill.lower().replace(' ', '_')}_pct"] = round(
                100 * descriptions.str.contains(pattern, regex=True).mean(),
                1,
            )

        rows.append(row)

    summary = pd.DataFrame(rows).sort_values(
        "postings", ascending=False
    )

    RESULTS.mkdir(exist_ok=True)
    CHARTS.mkdir(exist_ok=True)
    summary.to_csv(RESULTS / "summary.csv", index=False)

    # Keep charts intentionally simple and readable.
    ordered = summary.sort_values("entry_level_pct", ascending=True)
    plt.figure(figsize=(8, 4.5))
    plt.barh(ordered["role_family"], ordered["entry_level_pct"])
    plt.xlabel("Entry-level share of postings with stated experience (%)")
    plt.tight_layout()
    plt.savefig(CHARTS / "entry_level_share.png", dpi=180)
    plt.close()

    ordered = summary.sort_values("median_salary", ascending=True)
    plt.figure(figsize=(8, 4.5))
    plt.barh(ordered["role_family"], ordered["median_salary"])
    plt.xlabel("Median normalized salary ($)")
    plt.tight_layout()
    plt.savefig(CHARTS / "median_salary.png", dpi=180)
    plt.close()

    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
