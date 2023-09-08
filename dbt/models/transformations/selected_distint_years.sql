{{ config(materialized='view') }}

select distinct year
  from {{ ref('unpivoted_nama-10r-2gdp') }}
