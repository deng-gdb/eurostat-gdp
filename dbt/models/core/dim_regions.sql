{{ config(materialized='table', schema='development_core') }}

select {{ dbt_utils.generate_surrogate_key(['notation']) }} as region_id,
       Notation   as notation,
       Definition as definition
  from {{ ref('regions_lookup') }}