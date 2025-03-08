{{ config(materialized='view') }}

SELECT
    CLAIMID AS claim_id,
    SITEID AS site_id,
    PRIMARYCLAIMID AS primary_claim_id,
    SEQUENCE AS sequence_number,
    DIAGCODE AS diagnosis_code
FROM {{ source('finthrive_healthcare', 'DIAGNOSISDETAIL') }}