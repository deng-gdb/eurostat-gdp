{{ config(materialized='table', schema='core') }}

select Notation,
       Definition
  from {{ ref('regions_lookup') }}