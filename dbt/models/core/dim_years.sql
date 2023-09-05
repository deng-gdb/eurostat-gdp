{{ config(materialized='table', schema='core') }}

select {{ dbt_utils.generate_surrogate_key(['year']) }} as year_id,
       year
  from {{ ref('selected_distint_years') }}