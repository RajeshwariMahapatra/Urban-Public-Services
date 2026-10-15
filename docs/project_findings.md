# NYC 311 Service Requests — Key Findings

## Project Overview

This project analyzes a 500,000-record sample of NYC 311 service requests created between January 1 and February 18, 2025. The goal is to understand public-service demand, resolution patterns, geographic differences, and submission-channel usage.

## 1. Complaint Demand

- **Heat/Hot Water** was the most frequent complaint type, with 92,508 requests.
- **Noise – Residential** followed with 86,125 requests.
- **Illegal Parking** ranked third, with 68,487 requests.
- NYPD and HPD accounted for approximately 74% of the sampled requests combined.

**Implication:** Demand is concentrated in a few complaint categories and agencies. These categories are useful starting points for understanding service workload.

## 2. Resolution Time

- The median resolution time was approximately 15 hours.
- The average was approximately 234 hours, substantially higher than the median.
- Some requests took hundreds or thousands of hours to resolve.

**Implication:** The difference between the median and average suggests a right-skewed distribution, with a smaller number of very long resolution times pulling up the average. Resolution time should be examined alongside the complaint type and responsible agency.

## 3. Geographic Patterns

- The Bronx had the highest request count in this sample, followed by Brooklyn and Queens.
- The most frequent complaint categories varied by borough.
- Manhattan had the highest average resolution time among the specified boroughs in the current analysis.

**Implication:** Service demand and resolution patterns vary geographically. Comparisons should account for differences in complaint mix and agency workload.

## 4. Submission Channels

| Channel | Total requests | Valid resolution durations | Average resolution time | Resolved within 24 hours |
|---|---:|---:|---:|---:|
| Online | 203,186 | 201,273 | 237.71 hours | 52.61% |
| Mobile | 132,739 | 131,941 | 42.04 hours | 80.86% |
| Phone | 130,618 | 129,311 | 317.38 hours | 42.59% |
| Unknown | 33,456 | 32,790 | 661.73 hours | 44.39% |
| Other | 1 | 1 | 2,057.47 hours | 0.00% |

**Implication:** Mobile-submitted requests had a much shorter average resolution time and a higher percentage of valid-duration requests resolved within 24 hours than online- or phone-submitted requests.

This is an association, not proof that the submission channel causes faster resolution. Differences in complaint types, agencies, and other factors may explain the pattern. The `Other` category has only one record and should not be used for general conclusions.

## 5. Data Quality and Limitations

- The dataset contains 500,000 records, with no duplicate rows or duplicate request IDs detected.
- Missing values were retained where appropriate rather than automatically imputed.
- Negative resolution durations were excluded from resolution-time calculations but the associated requests were retained.
- Invalid ZIP-code values were converted to missing values.
- The sample covers January 1 through February 18, 2025, not the entire year.
- Resolution time measures the elapsed time between request creation and recorded closure; it does not independently measure service quality or the complexity of the work.

## 6. Recommended Next Steps

1. Build a Power BI dashboard to explore complaint demand, geography, resolution time, and submission channels.
2. Add filters for date, borough, agency, and complaint type.
3. Compare channels within similar agencies and complaint types before drawing stronger conclusions.
4. Clearly display the sample period and data limitations in the dashboard.
