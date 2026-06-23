# Hotel Bookings Analysis — Business Analyst Intern Technical Assessment

## Project Overview
End-to-end analysis of a 12,000-row hotel bookings dataset covering data quality checks,
a cancellation case study, SQL schema design, and a live weather API integration.
Built in Python (pandas, matplotlib, seaborn) and MySQL.

---

## Folder Structure

```
hotel_analysis/
├── answers.pdf                        ← All written answers with visualizations
├── hotel_bookings (1).csv             ← Source dataset (12,000 rows, 28 columns)
│
├── code/
│   ├── analysis.ipynb                 ← Main analysis notebook (Sections 1 + 2)
│   ├── cancellation_landscape.png     ← Section 2 visualization (auto-saved)
│   ├── schema.sql                     ← Normalized CREATE TABLE statements
│   └── queries.sql                    ← SQL queries using RANK() and LAG()
│
└── project/
    ├── weather_analyzer.ipynb         ← Section 4 weather API mini-project
    ├── weather_cancellation.png       ← Weather vs cancellation chart (auto-saved)
    ├── README.md                      ← This file
    └── ai_usage_note.txt              ← Specific notes on AI usage and fixes
```

---

## How to Run

### Prerequisites
Install required Python libraries:
```bash
pip install pandas matplotlib seaborn numpy requests jupyter
```

### Section 1 + 2 — Main Analysis
```bash
cd hotel_analysis/code
jupyter notebook analysis.ipynb
```
Run all cells top to bottom using Shift+Enter.
Make sure `hotel_bookings (1).csv` is in the same folder as the notebook.

### Section 3 — SQL
```bash
# Open MySQL Workbench
# Run schema.sql first (creates tables)
# Then run queries.sql (executes the two queries)
```

### Section 4 — Weather API Project
```bash
cd hotel_analysis/project
jupyter notebook weather_analyzer.ipynb
```
Requires internet connection for the Open-Meteo API call.
Run all cells top to bottom. Chart saves automatically.

---

## Section Summaries

### Section 1 — Data Quality Checks
Three data quality checks on the raw dataset:
- **A1:** 120 bookings have invalid stays (checkout ≤ check-in date)
- **A2:** Corporate segment appears highest rated (avg 7.25/10) but after
  normalizing to a 1–5 scale, Corporate (3.62) is actually the lowest rated
  segment — a scale mismatch that misleads any raw cross-segment comparison
- **A3:** Realized revenue for Luxury properties = ₹90,694,052.93
  (restricted to Completed bookings only, per Footnote 8)

### Section 2 — Cancellation Case Study
Platform cancellation rate: **19.2%** (industry benchmark: 12%, board target: 14%)

Key findings:
- **Worst meaningful slice:** Manali | 31–90 day lead time (30.7% cancel rate, 218 bookings)
- **Root cause:** Genuine city-season effect — October spike (31.7%) aligns with
  Rohtang Pass road closures due to early snowfall
- **Recommendation:** Opt-in 20% non-refundable deposit + 8% discount for
  Manali bookings with 31–90 day lead time
- **Expected impact:** 0.2–0.3 percentage point reduction in platform-wide
  cancellation rate (covers 4–6% of the board's 5pp target)

### Section 3 — SQL Schema + Queries
Normalized schema with 4 tables:

| Table | Primary Key | Key Constraints |
|---|---|---|
| customers | customer_id | NOT NULL on segment, loyalty_tier |
| properties | property_id | UNIQUE(property_name, property_city) — Footnote 4 |
| bookings | booking_id | CHECK(checkout > checkin) — Footnote 1, CHECK(num_rooms > 0) — Footnote 3 |
| reviews | review_id | UNIQUE(booking_id), CHECK(rating BETWEEN 1 AND 10) |

Two queries:
- **Query 1:** Top revenue property per city using `RANK() OVER (PARTITION BY property_city)`
- **Query 2:** Count of customers with average gap under 30 days between bookings using `LAG()`

### Section 4 — Weather API Mini-Project
API used: Open-Meteo Historical Weather (ERA5) — free, no key required

**Design decision:** One API call per city covering the full 2024 date range
(not one call per booking row) — reduces total API calls from 1,500+ to 2.

**Key insight:** Heavy rainfall on check-in day is strongly associated with
higher cancellation rates in Goa (36.5%) vs normal weather days (23.0%) —
a 13.5 percentage point difference across 211 rainy-day bookings. This effect
is almost entirely absent in Manali (22.1% vs 21.1%), revealing that
weather-driven cancellations concentrate in beach destinations where weather
defines the experience, not mountain destinations where adverse weather
is anticipated and accepted.

---

## Key Data Footnotes Handled

| Footnote | Issue | How Handled |
|---|---|---|
| 1 | Checkout ≤ check-in date | Filtered out in cleaning + CHECK constraint in SQL |
| 2 | Booking before signup date | Flagged, kept for analysis |
| 3 | Zero room bookings | Filtered out in cleaning + CHECK constraint in SQL |
| 4 | Property name repeats across cities | Always grouped by property_id, never property_name |
| 5 | Cancelled bookings with reviews | Flagged as impossible — counted (50 rows) |
| 6 | Dual rating scales (1–5 vs 1–10) | Corporate ratings divided by 2 before comparison |
| 7 | String 'None' in loyalty tier | keep_default_na=False in pd.read_csv() |
| 8 | Cancelled bookings carry total_amount | Only Completed bookings counted as realized revenue |

---

## Tools and Libraries

| Tool | Purpose |
|---|---|
| Python 3 | Core analysis language |
| pandas | Data loading, cleaning, filtering, aggregation |
| matplotlib | Chart creation |
| seaborn | Chart styling |
| numpy | Numerical operations |
| requests | HTTP calls to weather API |
| MySQL + Workbench | SQL schema design and query execution |
| Open-Meteo ERA5 API | Historical weather data (free, no key) |
| Jupyter Notebook | Interactive analysis environment |

---

## Author
Business Analyst Intern Technical Assessment — Question Set A
