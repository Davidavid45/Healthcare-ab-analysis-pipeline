{{ config(materialized='table') }}

WITH base_claims AS (
    SELECT
        c.claim_id,
        c.site_id,
        c.claim_type_code,
        c.statement_from_date,
        c.statement_thru_date,
        c.total_charges,
        c.estimated_amount_due
    FROM {{ ref('int_claims_summary') }} c
),

claim_costs AS (
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

patient_conditions AS (
    SELECT
        claim_id,
        total_diagnoses,
        all_diagnoses
    FROM {{ ref('int_patient_conditions') }}
),

procedures AS (
    SELECT
        claim_id,
        total_procedures
    FROM {{ ref('int_procedures_performed') }}
),

ab_test_data AS (
    SELECT
        claim_id,
        test_group  
    FROM {{ ref('int_a_b_test_data') }}
)

SELECT
    bc.claim_id,
    bc.site_id,
    bc.claim_type_code,
    bc.statement_from_date,
    bc.statement_thru_date,
    bc.total_charges,
    bc.estimated_amount_due,
    
    COALESCE(cc.total_charge_amount, 0) AS total_charge_amount,
    COALESCE(cc.total_charge_lines, 0) AS total_charge_lines,
    COALESCE(cc.total_paid_amount, 0) AS total_paid_amount,
    COALESCE(cc.total_service_line_amount, 0) AS total_service_line_amount,
    COALESCE(cc.eob_entries, 0) AS eob_entries,
    COALESCE(cc.total_adjustment_amount, 0) AS total_adjustment_amount,
    
    COALESCE(pc.total_diagnoses, 0) AS total_diagnoses,
    pc.all_diagnoses,
    
    COALESCE(pr.total_procedures, 0) AS total_procedures,
    
    ab.test_group  

FROM base_claims bc
LEFT JOIN claim_costs cc ON bc.claim_id = cc.claim_id
LEFT JOIN patient_conditions pc ON bc.claim_id = pc.claim_id
LEFT JOIN procedures pr ON bc.claim_id = pr.claim_id
LEFT JOIN ab_test_data ab ON bc.claim_id = ab.claim_id