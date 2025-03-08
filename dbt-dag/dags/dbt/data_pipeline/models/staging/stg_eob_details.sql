{{ config(materialized='view') }}

SELECT
    CLAIMID AS claim_id,
    SITEID AS site_id,
    EOBID AS eob_id,
    PRIMARYCLAIMID AS primary_claim_id,
    EOBTYPE AS eob_type,
    PAIDAMOUNT AS paid_amount,
    BILLEDAMOUNT AS billed_amount,
    TYPEOFBILL AS type_of_bill,
    CHECKNUMBER AS check_number,
    PAYEENPI AS payee_npi,
    REMITPAYERNAME AS remit_payer_name,
    EOBPAYERNAME AS eob_payer_name,
    BILLDATE AS bill_date
FROM {{ source('finthrive_healthcare', 'EOBDETAIL') }}