# Snowflake dbt Analytics

A portfolio Data Engineering project built with **dbt Core** and **Snowflake**, demonstrating a full layered analytics architecture (Landing → Staging → Intermediate → Mart) using real-world blockchain financial data.

---

## Project Overview

This project ingests and transforms **Bitcoin (BTC) historical transaction data** sourced from a public AWS S3 bucket (`s3://aws-public-blockchain/v1.0/btc/`) into Snowflake, and models it through dbt layers to produce clean, analytics-ready tables.

Ingestion is handled by a **Snowflake Task** running on a 2-hour schedule using `COPY INTO` from an external S3 stage. dbt then picks up from the landing layer and transforms the data through three model layers.

It is designed as a growing portfolio project — Ethereum data and additional models will be added incrementally.

---

## Tech Stack

| Component | Technology |
|-----------|-----------|
| Data Warehouse | Snowflake |
| Transformation | dbt Core |
| Source Data | Bitcoin historical transactions — public AWS S3 (`aws-public-blockchain`) |
| Ingestion | Snowflake External Stage + COPY INTO + Snowflake Task (2-hour schedule) |
| File Format | Parquet (`.snappy.parquet`) |
| Language | SQL |
| Environment | Python venv + dbt-snowflake |
| Visualisation | Power BI (planned) |

---

## Architecture

```
s3://aws-public-blockchain/v1.0/btc/transactions/
        │
        │  Snowflake External Stage (STAGE_BTC)
        │  Snowflake Task — COPY INTO every 2 hours
        ▼
  DBT_ANALYTICS_DEV.LANDING     ← raw BTC table, loaded by Snowflake Task
        │
        │  dbt reads LANDING as source
        ▼
  DBT_ANALYTICS_DEV.STAGING     ← dbt stg_ models (standardise, rename, cast types)
        │
        ▼
  DBT_ANALYTICS_DEV.INTERMEDIATE ← dbt int_ models (business logic, transformations)
        │
        ▼
  DBT_ANALYTICS_DEV.MART        ← dbt mart_ models (analytics-ready, reporting)
        │
        ▼
     Power BI
```

---

## Snowflake Database & Schema Design

Two databases — one per environment. Each contains four schemas:

```
DBT_ANALYTICS_DEV                        DBT_ANALYTICS_PROD
├── LANDING      ← COPY INTO target      ├── LANDING
│     Stage: STAGE_BTC                   │     Stage: STAGE_BTC
│     Table: BTC                         │     Table: BTC
├── STAGING      ← dbt stg_ models       ├── STAGING
├── INTERMEDIATE ← dbt int_ models       ├── INTERMEDIATE
└── MART         ← dbt mart_ models      └── MART
```

| Schema | Owner | Purpose |
|--------|-------|---------|
| `LANDING` | Snowflake Task | Raw data loaded directly from S3 via COPY INTO. dbt never writes here — only reads. |
| `STAGING` | dbt | Standardise column names, cast types, light cleaning. One model per source table. |
| `INTERMEDIATE` | dbt | Business logic, joins, reusable transformations. Not exposed to BI tools. |
| `MART` | dbt | Final analytics-ready tables consumed by Power BI. |

> **Note:** `LANDING` is kept source-agnostic (not `BTC_LANDING`) so Ethereum and other blockchain data can be added as separate tables within the same schema later.

---

## dbt Sources Wiring

```yaml
# models/staging/sources.yml
sources:
  - name: landing
    database: DBT_ANALYTICS_DEV
    schema: LANDING
    tables:
      - name: btc
      - name: eth   # planned
```

---

## Project Structure

```
snowflake_dbt_analytics/       ← dbt project root
├── models/
│   ├── staging/               ← stg_ models (coming soon)
│   ├── intermediate/          ← int_ models (coming soon)
│   └── mart/                  ← mart_ models (coming soon)
│   └── sources/                  ← mart_ models (coming soon)
│   │     └── src_staging.yml
├── seeds/
├── snapshots/
├── tests/
├── macros/
└── dbt_project.yml
```

---

## Status

- [x] Project initialised (dbt init + Snowflake connection)
- [x] Snowflake connection verified (`dbt debug`)
- [x] Database & schema design finalised
- [ ] Snowflake LANDING schema + STAGE_BTC + BTC table created
- [ ] Snowflake Task configured (COPY INTO every 2 hours)
- [ ] BTC data loaded into LANDING.BTC
- [ ] Staging models (`stg_btc_transactions`)
- [ ] Intermediate models
- [ ] Mart models
- [ ] dbt tests and documentation
- [ ] Power BI connection

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
- [Snowflake Key Pair Authentication](https://docs.snowflake.com/en/user-guide/key-pair-auth)
- [AWS Public Blockchain Data](https://registry.opendata.aws/aws-public-blockchain/)
- [dbt Community Slack](https://community.getdbt.com/)
