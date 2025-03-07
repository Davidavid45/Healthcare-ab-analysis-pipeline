# Healthcare-ab-analysis-pipeline

## 📌 Project Overview
This project demonstrates the ability to work with **DBT, Snowflake, and Airflow** to build a **healthcare claims data pipeline**. The goal was to **ingest, transform, and analyze** claims data while performing **A/B testing** on total paid amounts.

## 🚀 Technologies Used
- **DBT** – For data transformation and modeling
- **Snowflake** – As the cloud data warehouse
- **Airflow** – For orchestrating and scheduling pipeline runs
- **Python (Snowpark)** – For analytical processing in Snowflake
- **Pandas & SciPy** – For statistical analysis in Jupyter Notebook

## 📂 Project Structure
├── 📂 data_pipeline/
│   ├── 📂 models/
│   │   ├── 📂 staging/              # Staging tables
│   │   ├── 📂 intermediate/         # Intermediate transformations
│   │   ├── 📂 marts/                # Final transformed data marts
│   │   ├── 📄 dbt_project.yml       # DBT configuration
│   ├── 📂 seeds/                    # Seed data for DBT
│   ├── 📂 tests/                    # DBT tests
│   ├── 📂 macros/                   # Reusable DBT macros
│
├── 📂 airflow_dags/                  # Airflow DAGs for ETL orchestration
│   ├── 📄 dbt_dag.py                 # DAG that runs DBT models
│   ├── 📂 dependencies/              # Airflow dependencies
│
├── 📂 notebooks/                     # Jupyter Notebooks for analysis
│   ├── 📄 A_B_ANALYSIS.ipynb          # A/B testing results
│
├── 📂 sql_queries/                   # SQL queries for Snowflake
│   ├── 📄 claims_analysis.sql        # SQL for claims transformations
│
└── 📄 README.md                      # Project documentation                        

├── data_pipeline/
│   ├── models/
│   │   ├── staging/             # Staging tables
│   │   ├── intermediate/        # Intermediate transformations
│   │   ├── marts/               # Final transformed data marts
│   │   ├── dbt_project.yml      # DBT configuration
│   ├── seeds/                   # Seed data for DBT
│   ├── tests/                   # DBT tests
│   ├── macros/                   # Reusable DBT macros
│
├── airflow_dags/                # Airflow DAGs for ETL orchestration
│   ├── dbt_dag.py               # DAG that runs DBT models
│   ├── dependencies/            # Airflow dependencies
│
├── notebooks/                   # Jupyter Notebooks for analysis
│   ├── A_B_ANALYSIS.ipynb       # A/B testing results
│
├── sql_queries/                 # SQL queries for Snowflake
│   ├── claims_analysis.sql      # SQL for claims transformations
│
└── README.md                    # Project documentation

## 📊 A/B Testing Analysis
**Objective:**  
The A/B test was conducted to evaluate the difference in **Total Paid Amounts** between **Group A and Group B**.

### Hypothesis:
- **H₀ (Null Hypothesis):** No significant difference between Group A and Group B.
- **H₁ (Alternative Hypothesis):** A significant difference exists in Total Paid Amounts.

### Key Steps:
1. Loaded the **FACT_AB_TEST_DATA** table from Snowflake.
2. Performed **data exploration** and checked for missing values.
3. Used **Shapiro-Wilk test** to check for normality (data was not normally distributed).
4. Conducted **Mann-Whitney U test** (since data was non-parametric).
5. Visualized distributions using **box plots & histograms**.

#### **Results:**
- **p-value: 0.70** (Mann-Whitney U Test)
- No statistically significant difference between **Group A and Group B**.
