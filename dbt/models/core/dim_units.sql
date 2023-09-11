{{ config(materialized='table') }}

select {{ dbt_utils.generate_surrogate_key(['id']) }} 
             as unit_id,
       id    as unit_code,
       label as unit_name
  from {{ ref('units_lookup') }}