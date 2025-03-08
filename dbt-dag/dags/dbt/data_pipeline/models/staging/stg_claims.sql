{{ config(materialized='view') }}

SELECT
    CLAIMID AS claim_id,
    SITEID AS site_id,
    PRIMARYCLAIMID AS primary_claim_id,
    ROOTCLAIMID AS root_claim_id,
    BSEQ AS batch_seq,
    NPay AS net_payment,
    LINKEDCLAIMTYPECODE AS linked_claim_type_code,
    LINKEDCLAIMTYPEDESC AS linked_claim_type_desc,
    BILLEDDATE AS billed_date,
    IMPORTDATE AS import_date,
    EXPORTDATE AS export_date,
    STMFROM AS statement_from_date,
    STMTHRU AS statement_thru_date,
    CLAIMTYPECODE AS claim_type_code,
    CLAIMTYPENAME AS claim_type_name,
    TOB AS type_of_bill,
    TOBTYPE AS tob_type,
    TOBFACILITYTYPE AS tob_facility_type,
    TOTALCHARGES AS total_charges,
    ESTAMTDUe AS estimated_amount_due
FROM {{ source('finthrive_healthcare', 'CLAIMDETAIL') }}