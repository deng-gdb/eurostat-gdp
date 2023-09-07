{{ config(materialized='table',schema='development_core') }}

select {{ dbt_utils.generate_surrogate_key(['id']) }} as unit_id,
       id,
       label
  from {{ ref('units_lookup') }}