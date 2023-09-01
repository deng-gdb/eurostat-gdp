{{ config(materialized='view', schema='staging') }}

select trim(string_field_0) as unit,
       trim(string_field_1) as geo, 
       cast(REGEXP_REPLACE(string_field_2, r"[^0-9.]", "") as numeric) as year_2021,
       cast(REGEXP_REPLACE(string_field_3, r"[^0-9.]", "") as numeric) as year_2020,
       cast(REGEXP_REPLACE(string_field_4, r"[^0-9.]", "") as numeric) as year_2019,
       cast(REGEXP_REPLACE(string_field_5, r"[^0-9.]", "") as numeric) as year_2018,

       cast(double_field_6 as numeric)                                 as year_2017,

       cast(REGEXP_REPLACE(string_field_7, r"[^0-9.]", "") as numeric) as year_2016,
       cast(REGEXP_REPLACE(string_field_8, r"[^0-9.]", "") as numeric) as year_2015,
       cast(double_field_9 as numeric)                                  as year_2014,
       cast(REGEXP_REPLACE(string_field_10, r"[^0-9.]", "") as numeric) as year_2013,
       cast(REGEXP_REPLACE(string_field_11, r"[^0-9.]", "") as numeric) as year_2012,
       cast(REGEXP_REPLACE(string_field_12, r"[^0-9.]", "") as numeric) as year_2011,
       cast(REGEXP_REPLACE(string_field_13, r"[^0-9.]", "") as numeric) as year_2010,
       cast(REGEXP_REPLACE(string_field_14, r"[^0-9.]", "") as numeric) as year_2009,
       cast(REGEXP_REPLACE(string_field_15, r"[^0-9.]", "") as numeric) as year_2008,
       cast(REGEXP_REPLACE(string_field_16, r"[^0-9.]", "") as numeric) as year_2007,
       cast(REGEXP_REPLACE(string_field_17, r"[^0-9.]", "") as numeric) as year_2006,
       cast(REGEXP_REPLACE(string_field_18, r"[^0-9.]", "") as numeric) as year_2005,
       cast(REGEXP_REPLACE(string_field_19, r"[^0-9.]", "") as numeric) as year_2004,
       cast(REGEXP_REPLACE(string_field_20, r"[^0-9.]", "") as numeric) as year_2003,
       cast(REGEXP_REPLACE(string_field_21, r"[^0-9.]", "") as numeric) as year_2002,
       cast(REGEXP_REPLACE(string_field_22, r"[^0-9.]", "") as numeric) as year_2001,
       cast(REGEXP_REPLACE(string_field_23, r"[^0-9.]", "") as numeric) as year_2000
  from {{ source('staging','nama-10r-2gdp') }}
