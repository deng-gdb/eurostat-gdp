{{ config(materialized='view', schema='intermediate') }}

select unit,
       geo,
       year,
       cast(REGEXP_REPLACE(value, r"[^0-9.]", NULL) as numeric)  as `value`
  from {{ ref('unpivoted_nama-10r-2gdp') }}