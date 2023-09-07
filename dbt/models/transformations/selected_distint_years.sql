{{ config(materialized='view', schema='development_transformations') }}

select distinct year
  from {{ ref('unpivoted_nama-10r-2gdp') }}
