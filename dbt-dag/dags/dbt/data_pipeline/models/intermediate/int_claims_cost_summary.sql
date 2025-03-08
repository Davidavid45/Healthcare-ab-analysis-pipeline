{{ config(materialized='table') }}

WITH claim_charges AS (
    SELECT
        claim_id,
        SUM(charge_amount) AS total_charge_amount,
        COUNT(*) AS total_charge_lines
    FROM {{ ref('stg_claim_charges') }}
    GROUP BY claim_id
),

eob_details AS (
    SELECT
        claim_id,
        SUM(paid_amount) AS total_paid_amount,
        SUM(billed_amount) AS total_service_line_amount,
        COUNT(DISTINCT eob_id) AS eob_entries
    FROM {{ ref('stg_eob_details') }}
    GROUP BY claim_id
),

eob_adjustments AS (
    SELECT
        d.claim_id,
        SUM(r.amount) AS total_adjustment_amount
    FROM {{ ref('stg_eob_remark_codes') }} r
    JOIN {{ ref('stg_eob_details') }} d
        ON r.eob_id = d.eob_id
    GROUP BY d.claim_id
)

SELECT
    c.claim_id,
    COALESCE(cc.total_charge_amount, 0) AS total_charge_amount,
    COALESCE(cc.total_charge_lines, 0) AS total_charge_lines,
    COALESCE(ed.total_paid_amount, 0) AS total_paid_amount,
    COALESCE(ed.total_service_line_amount, 0) AS total_service_line_amount,
    COALESCE(ed.eob_entries, 0) AS eob_entries,
    COALESCE(ea.total_adjustment_amount, 0) AS total_adjustment_amount
FROM {{ ref('stg_claims') }} c
LEFT JOIN claim_charges cc ON c.claim_id = cc.claim_id
LEFT JOIN eob_details ed ON c.claim_id = ed.claim_id
LEFT JOIN eob_adjustments ea ON c.claim_id = ea.claim_id