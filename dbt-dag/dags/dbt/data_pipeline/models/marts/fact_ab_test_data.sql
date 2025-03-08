{{ config(materialized='table') }}

WITH base_claims AS (
    SELECT
        claim_id,
        site_id,
        statement_from_date,
        statement_thru_date,
        total_charge_amount,
        total_paid_amount,
        total_adjustment_amount,
        total_diagnoses,
        total_procedures
    FROM {{ ref('fact_claims') }}
),

ab_groups AS (
    SELECT
        claim_id,
        CASE WHEN claim_id % 2 = 0 THEN 'A' ELSE 'B' END AS test_group
    FROM base_claims
),

joined_ab AS (
    SELECT
        bc.claim_id,
        bc.site_id,
        bc.statement_from_date,
        bc.statement_thru_date,
        bc.total_charge_amount,
        bc.total_paid_amount,
        bc.total_adjustment_amount,
        bc.total_diagnoses,
        bc.total_procedures,
        ag.test_group
    FROM base_claims bc
    INNER JOIN ab_groups ag ON bc.claim_id = ag.claim_id
),

ab_metrics AS (
    SELECT
        claim_id,
        site_id,
        test_group,
        total_charge_amount,
        total_paid_amount,
        total_adjustment_amount,
        total_diagnoses,
        total_procedures,
        CASE 
            WHEN total_charge_amount = 0 THEN 0 
            ELSE (total_paid_amount / total_charge_amount) 
        END AS reimbursement_ratio
    FROM joined_ab
)

SELECT *
FROM ab_metrics