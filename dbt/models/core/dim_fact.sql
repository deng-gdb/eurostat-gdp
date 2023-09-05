{{ config(materialized='table', schema='core') }}

select unit,
       geo,
       year,
       value
  from {{ ref('casted_to_numeric_nama-10r-2gdp') }}
 