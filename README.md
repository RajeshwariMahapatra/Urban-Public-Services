# Urban Public Services Intelligence Platform

## Project Overview

An end-to-end data analytics project exploring NYC 311 service requests using Python, SQL, and Power BI. The goal is to understand complaint demand, resolution patterns, geographic differences, and submission-channel trends.

## Tools & Technologies

Python: Pandas, NumPy, Matplotlib, Seaborn

SQL: MySQL, aggregations, CTEs, window functions, data validation

Power BI: KPI cards, bar charts, slicers, cross-page filtering

Git & GitHub: Version control and project documentation

## Business Questions

Which complaint types generate the most service requests?

Which agencies receive the highest request volumes?

How do resolution times differ by agency and borough?

What percentage of requests are resolved within 24 hours?

How do request volume and resolution patterns vary by submission channel?

## Objectives

- Analyze public-service requests and complaints
- Identify demand patterns across locations and service categories
- Measure service resolution performance
- Detect unusual patterns and potential service gaps
- Build an interactive Power BI dashboard
- Demonstrate an end-to-end data analytics workflow

## Dataset

Source: NYC Open Data — 311 Service Requests from 2020 to Present.

This project uses a controlled sample of 500,000 records created between January 1 and February 18, 2025. It is not a complete dataset for 2025.

The raw and processed CSV files are excluded from version control because of their size. Refer to the source dataset and the project scripts to understand the data acquisition and preparation process.

## Analysis Workflow

1. Retrieved a 500,000-record sample through the NYC Open Data API.

2. Used Python to inspect data types, missing values, duplicates, and invalid resolution durations.

3. Cleaned and prepared the dataset while preserving service requests with incomplete resolution information.

4. Loaded the cleaned data into MySQL and validated the imported records.

5. Wrote SQL queries to analyse demand, resolution times, borough patterns, and submission channels.

6. Built a multi-page Power BI report with KPI cards, charts, slicers, and synchronized filtering.

## Project Pipeline

Raw Data
→ Data Cleaning
→ Data Validation
→ SQL Analysis
→ Data Modeling
→ Power BI
→ Insights

## Key Findings

Complaint demand: Heat/Hot Water, Noise – Residential, and Illegal Parking were the three most frequent complaint types in the sample.

Agency demand: NYPD and HPD accounted for approximately 74% of all sampled requests.

Submission channels: Online and mobile submissions together represented approximately 67% of the sample.

Resolution patterns: Median resolution time was approximately 15 hours, while the average was much higher, indicating a strongly right-skewed distribution.

Geographic variation: Complaint mix and resolution patterns differed across boroughs.

These are descriptive findings from the selected sample, not proof of causation or a definitive assessment of agency performance.

## Data Quality & Limitations

The dataset covers only January 1–February 18, 2025, so it does not represent the entire year.

Requests without valid resolution durations were retained for demand analysis but excluded from duration-based calculations.

Extremely long resolution times can affect averages; medians and sample sizes should also be considered.

Differences between agencies, boroughs, and channels may reflect differences in complaint mix and operational responsibilities.

The findings describe this sample and should not automatically be generalized to all NYC 311 requests.

## Repository Structure

python/ — data exploration and cleaning notebook
sql/ — database setup, validation, and analytical queries
powerbi/ — Power BI report
docs/screenshots/ — report screenshots
data/ — local raw and processed data, excluded from GitHub

## How to Reproduce

Download the relevant data from NYC Open Data.
Follow the Python notebook for exploration and cleaning.
Follow the SQL scripts in sequence to create, validate, and analyse the MySQL table.
Open the Power BI report to explore the dashboard.