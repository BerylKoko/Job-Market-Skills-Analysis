"""Cleaning helpers for Job Market & Skills Analysis."""

import re
import pandas as pd

POSTING_COLUMNS = [
    "job_id",
    "title",
    "description",
    "location",
    "formatted_experience_level",
    "normalized_salary",
    "remote_allowed",
    "formatted_work_type",
]

def classify_role(title):
    title = str(title).lower()

    if re.search(r"\\b(product manager|associate product manager|product management)\\b", title):
        return "Product management"
    if re.search(r"\\bproduct analyst\\b", title):
        return "Product analyst"
    if re.search(r"\\b(business intelligence|bi analyst|business intelligence analyst)\\b", title):
        return "Business intelligence"
    if re.search(r"\\b(business systems analyst|business system analyst|business analyst)\\b", title):
        return "Business analyst"
    if re.search(r"\\b(data analyst|analytics analyst|data analytics analyst)\\b", title):
        return "Data analyst"

    return pd.NA

def load_target_postings(path="postings.csv"):
    postings = pd.read_csv(path, usecols=POSTING_COLUMNS)
    postings["role_family"] = postings["title"].apply(classify_role)

    target = postings.dropna(subset=["role_family"]).copy()
    target["formatted_experience_level"] = (
        target["formatted_experience_level"]
        .fillna("Missing")
        .replace("", "Missing")
    )
    target["normalized_salary"] = pd.to_numeric(
        target["normalized_salary"],
        errors="coerce",
    )
    target.loc[target["normalized_salary"] <= 0, "normalized_salary"] = pd.NA
    return target

if __name__ == "__main__":
    df = load_target_postings()
    print(df["role_family"].value_counts())
