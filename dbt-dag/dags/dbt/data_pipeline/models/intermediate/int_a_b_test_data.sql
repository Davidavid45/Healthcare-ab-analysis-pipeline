{{ config(materialized='table') }}

WITH base AS (
    SELECT
        cs.claim_id,
        cs.claim_type_code,
        cs.statement_from_date,
        cs.statement_thru_date,
        cs.total_charges,
        cs.estimated_amount_due
    FROM {{ ref('int_claims_summary') }} cs
),

costs AS (
    SELECT
        claim_id,
        total_charge_amount,
        total_charge_lines,
        total_paid_amount,
        total_service_line_amount,
        eob_entries,
        total_adjustment_amount
    FROM {{ ref('int_claims_cost_summary') }}
),

conditions AS (
    SELECT
        claim_id,
        total_diagnoses
    FROM {{ ref('int_patient_conditions') }}
),

procedures AS (
    SELECT
        claim_id,
        total_procedures
    FROM {{ ref('int_procedures_performed') }}
),

merged_data AS (
    SELECT
        b.claim_id,
        b.claim_type_code,
        b.statement_from_date,
        b.statement_thru_date,
        b.total_charges,
        b.estimated_amount_due,

        c.total_charge_amount,
        c.total_charge_lines,
        c.total_paid_amount,
        c.total_service_line_amount,
        c.eob_entries,
        c.total_adjustment_amount,

        co.total_diagnoses,
        p.total_procedures
    FROM base b
    LEFT JOIN costs c ON b.claim_id = c.claim_id
    LEFT JOIN conditions co ON b.claim_id = co.claim_id
    LEFT JOIN procedures p ON b.claim_id = p.claim_id
),

ab_flags AS (
    SELECT
        md.*,
        CASE 
            WHEN md.claim_id % 2 = 0 THEN 'A' 
            ELSE 'B' 
        END AS test_group
    FROM merged_data md
)

SELECT *
FROM ab_flags