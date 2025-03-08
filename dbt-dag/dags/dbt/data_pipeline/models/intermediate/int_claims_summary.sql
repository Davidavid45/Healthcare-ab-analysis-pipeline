{{ config(materialized='table') }}

WITH claim_base AS (
    SELECT 
        claim_id,
        site_id,
        primary_claim_id,
        root_claim_id,
        billed_date,
        statement_from_date,
        statement_thru_date,
        claim_type_code,
        claim_type_name,
        type_of_bill,
        tob_facility_type,
        total_charges,
        estimated_amount_due
    FROM {{ ref('stg_claims') }}
),

charge_summary AS (
    SELECT 
        claim_id,
        SUM(charge_amount) AS total_charge_amount,
        COUNT(DISTINCT charge_id) AS total_charge_lines
    FROM {{ ref('stg_claim_charges') }}
    GROUP BY claim_id
),

diagnosis_summary AS (
    SELECT 
        claim_id,
        COUNT(DISTINCT diagnosis_code) AS total_diagnoses
    FROM {{ ref('stg_diagnosis') }}
    GROUP BY claim_id
),

procedure_summary AS (
    SELECT 
        claim_id,
        COUNT(DISTINCT procedure_code) AS total_procedures
    FROM {{ ref('stg_procedure') }}
    GROUP BY claim_id
)

SELECT 
    cb.*,
    COALESCE(cs.total_charge_amount, 0) AS total_charge_amount,
    COALESCE(cs.total_charge_lines, 0) AS total_charge_lines,
    COALESCE(ds.total_diagnoses, 0) AS total_diagnoses,
    COALESCE(ps.total_procedures, 0) AS total_procedures
FROM claim_base cb
LEFT JOIN charge_summary cs ON cb.claim_id = cs.claim_id
LEFT JOIN diagnosis_summary ds ON cb.claim_id = ds.claim_id
LEFT JOIN procedure_summary ps ON cb.claim_id = ps.claim_id