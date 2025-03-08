{{ config(materialized='view') }}

SELECT
    CLAIMID AS claim_id,
    SITEID AS site_id,
    CHARGEID AS charge_id,
    CHARGEPROCEDURECODE AS procedure_code,
    CHARGEREVENUECODE AS revenue_code,
    CHARGES AS charge_amount,
    UNITS AS units
FROM {{ source('finthrive_healthcare', 'CLAIMCHARGEDETAIL') }}