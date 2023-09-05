{{ config(materialized='table',schema='core') }}

select *
  from {{ ref('units_lookup') }}