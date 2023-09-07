{{ config(materialized='view', schema='development_transformations') }}

select unit,
       geo,
       year,
       cast(trim(REGEXP_EXTRACT(value, r"[0-9.]+")) as numeric)  as `value`
  from {{ ref('unpivoted_nama-10r-2gdp') }}