{{ config(materialized='table') }}

select {{ dbt_utils.generate_surrogate_key(['notation']) }} 
                 as region_id,
       notation  as region_code,
       label     as region_name
  from {{ ref('regions_lookup') }}