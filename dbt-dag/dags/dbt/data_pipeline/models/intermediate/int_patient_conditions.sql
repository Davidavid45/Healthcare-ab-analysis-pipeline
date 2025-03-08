{{ config(materialized='table') }}

WITH diagnosis_base AS (
    SELECT
        d.claim_id,
        d.site_id,
        d.diagnosis_code,
        d.sequence_number,
        c.primary_claim_id  -- if needed
    FROM {{ ref('stg_diagnosis') }} d
    LEFT JOIN {{ ref('stg_claims') }} c
        ON d.claim_id = c.claim_id
),

diagnosis_agg AS (
    SELECT
        claim_id,
        site_id,
        COUNT(DISTINCT diagnosis_code) AS total_diagnoses,
        ARRAY_AGG(DISTINCT diagnosis_code) AS all_diagnoses  
    FROM diagnosis_base
    GROUP BY claim_id, site_id
)

SELECT
    da.claim_id,
    da.site_id,
    da.total_diagnoses,
    da.all_diagnoses  
FROM diagnosis_agg da