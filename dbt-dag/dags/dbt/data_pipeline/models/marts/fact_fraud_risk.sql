{{ config(materialized='table') }}

WITH claims_base AS (
    SELECT
        claim_id,
        site_id,
        total_charge_amount,
        total_paid_amount,
        total_adjustment_amount,
        total_diagnoses,
        total_procedures
    FROM {{ ref('fact_claims') }}
),

thresholds AS (
    SELECT
        percentile_cont(0.95) WITHIN GROUP (ORDER BY total_charge_amount) AS charge_95,
        percentile_cont(0.95) WITHIN GROUP (ORDER BY total_adjustment_amount) AS adj_95,
        percentile_cont(0.95) WITHIN GROUP (ORDER BY total_diagnoses) AS diag_95,
        percentile_cont(0.95) WITHIN GROUP (ORDER BY total_procedures) AS proc_95
    FROM claims_base
),

flagged AS (
    SELECT
        c.claim_id,
        c.site_id,
        c.total_charge_amount,
        c.total_paid_amount,
        c.total_adjustment_amount,
        c.total_diagnoses,
        c.total_procedures,

        CASE WHEN c.total_charge_amount        > t.charge_95 THEN 1 ELSE 0 END AS high_charge_flag,
        CASE WHEN c.total_adjustment_amount    > t.adj_95    THEN 1 ELSE 0 END AS high_adjustment_flag,
        CASE WHEN c.total_diagnoses            > t.diag_95   THEN 1 ELSE 0 END AS many_diagnoses_flag,
        CASE WHEN c.total_procedures           > t.proc_95   THEN 1 ELSE 0 END AS many_procedures_flag
    FROM claims_base c
    CROSS JOIN thresholds t
)

SELECT
    claim_id,
    site_id,
    total_charge_amount,
    total_paid_amount,
    total_adjustment_amount,
    total_diagnoses,
    total_procedures,
    high_charge_flag,
    high_adjustment_flag,
    many_diagnoses_flag,
    many_procedures_flag,
    (
        high_charge_flag 
        + high_adjustment_flag 
        + many_diagnoses_flag 
        + many_procedures_flag
    ) AS fraud_risk_score
FROM flagged