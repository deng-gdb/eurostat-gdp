{{ config(materialized='table', schema='core') }}

select unit,
       geo,
       year,
       value
  from {{ ref('unpivoted_nama-10r-2gdp') }}
 