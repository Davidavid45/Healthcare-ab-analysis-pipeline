{{ config(materialized='table') }}

WITH facility_base AS (
    SELECT
        provider_id     AS facility_id,    
        bed_size,
        region,
        geographic_classification,
        hospital_type,
        teaching_status,
        facility_zip
    FROM {{ ref('stg_providers') }}  
)

SELECT 
    facility_id,
    bed_size,
    region,
    geographic_classification,
    hospital_type,
    teaching_status,
    facility_zip
FROM facility_base