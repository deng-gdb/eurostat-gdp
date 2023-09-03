{{ config(materialized='table') }}

select *
  from {{ ref('units_lookup') }}