{{ config(materialized='table') }}

select Notation,
       Definition
  from {{ ref('regions_lookup') }}