{{ config(materialized='view') }}

SELECT
    SITEID AS site_id,
    EOBID AS eob_id,
    ADJUSTMENTTYPE AS adjustment_type,
    EOBCHARGEID AS eob_charge_id,
    GROUPCODE AS group_code,
    ADJUSTMENTCODE AS adjustment_code,
    REMARKCODE AS remark_code,
    CODE AS code,
    DESCRIPTION AS description,
    QUANTITY AS quantity,
    AMOUNT AS amount,
    PROCEDURECODE AS procedure_code,
    REVENUECODE AS revenue_code
FROM {{ source('finthrive_healthcare', 'EOBREMARKCODEDETAIL') }}