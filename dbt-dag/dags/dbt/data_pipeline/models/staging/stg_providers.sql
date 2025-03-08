{{ config(materialized='view') }}

SELECT
    PROVIDERID AS provider_id,
    BEDSIZE AS bed_size,
    REGION AS region,
    GEOGRAPHICCLASSIFICATION AS geographic_classification,
    HOSPITALTYPE AS hospital_type,
    TEACHINGSTATUS AS teaching_status,
    FACILITYZIP AS facility_zip
FROM {{ source('finthrive_healthcare', 'FACILITYDETAIL') }}