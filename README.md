# Snowflake dbt Analytics

A portfolio Data Engineering project built with **dbt Core** and **Snowflake**, demonstrating a layered analytics architecture (Staging → Intermediate → Mart) using real-world financial data.

---

## Project Overview

This project ingests and transforms **Bitcoin (BTC) historical price data** sourced from a public AWS S3 bucket into Snowflake, and models it through dbt layers to produce clean, analytics-ready tables.

It is designed as a growing portfolio project — models and functionality will be added incrementally.

---

## Tech Stack

| Component | Technology |
|-----------|-----------|
| Data Warehouse | Snowflake |
| Transformation | dbt Core |
| Source Data | Bitcoin historical data — public AWS S3 |
| Language | SQL |
| Environment | Python venv + dbt-snowflake |

---

## Architecture

```
Public AWS S3 (BTC raw data)
        │
        ▼
  Snowflake Raw / Source Table
        │
        ▼
  STAGING schema   ← dbt stg_ models (standardise, rename, cast)
        │
        ▼
  INTERMEDIATE schema  ← dbt int_ models (business logic, transformations)
        │
        ▼
  MART schema      ← dbt mart_ models (analytics-ready, reporting)
```

---

## Project Structure

```
snowflake_dbt_analytics/   ← dbt project root
├── models/
│   ├── staging/           ← stg_ models (coming soon)
│   ├── intermediate/      ← int_ models (coming soon)
│   └── mart/              ← mart_ models (coming soon)
├── seeds/
├── snapshots/
├── tests/
├── macros/
└── dbt_project.yml
```

---

## Setup

```bash
# Create and activate virtual environment
python -m venv .venv_sf_dbt
.venv_sf_dbt\Scripts\activate

# Install dependencies
pip install dbt-core==1.11.11 dbt-snowflake==1.11.2

# Verify
dbt --version

# Test Snowflake connection
cd snowflake_dbt_analytics
dbt debug
```

---

## Resources

- [dbt Documentation](https://docs.getdbt.com/docs/introduction)
- [Snowflake + dbt Guide](https://docs.getdbt.com/docs/core/connect-data-platform/snowflake-setup)
- [dbt Community Slack](https://community.getdbt.com/)
