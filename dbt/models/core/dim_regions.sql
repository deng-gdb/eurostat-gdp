{{ config(materialized='table') }}

with

regions as (

    select
        notation  as region_code,
        label     as region_name

    from {{ ref('regions_lookup') }}

),


facts as (

    select 
        geo
    from {{ ref('casted_to_numeric_nama-10r-2gdp') }}

)

select    
    {{ dbt_utils.generate_surrogate_key(['region_code']) }} 
                 as region_id,
    regions.region_code,
    regions.region_name
  from regions
 where exists (
    select geo
      from facts
 )
