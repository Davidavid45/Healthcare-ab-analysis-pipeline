{{ config(materialized='table') }}

WITH procedure_base AS (
    SELECT
        p.claim_id,
        p.procedure_code,
        c.site_id,
        c.primary_claim_id
    FROM {{ ref('stg_procedure') }} p
    LEFT JOIN {{ ref('stg_claims') }} c
        ON p.claim_id = c.claim_id
),

procedure_summary AS (
    SELECT
        claim_id,
        site_id,
        primary_claim_id,
        COUNT(DISTINCT procedure_code) AS total_procedures,
        ARRAY_AGG(DISTINCT procedure_code) AS procedure_codes
    FROM procedure_base
    GROUP BY claim_id, site_id, primary_claim_id
)

SELECT
    c.claim_id,
    c.site_id,
    c.primary_claim_id,
    COALESCE(ps.total_procedures, 0) AS total_procedures,
FROM {{ ref('stg_claims') }} c
LEFT JOIN procedure_summary ps
    ON c.claim_id = ps.claim_id