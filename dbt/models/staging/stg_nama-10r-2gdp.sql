{{ config(materialized='view', schema='staging') }}

select trim(string_field_0) as unit,
       trim(string_field_1) as geo,
       cast(REGEXP_REPLACE(string_field_2, r"[^0-9.]", null) as numeric)  as `2021`,
       cast(REGEXP_REPLACE(string_field_3, r"[^0-9.]", NULL) as numeric)  as `2020`,
       cast(REGEXP_REPLACE(string_field_4, r"[^0-9.]", NULL) as numeric)  as `2019`,
       cast(REGEXP_REPLACE(string_field_5, r"[^0-9.]", NULL) as numeric)  as `2018`,

       cast(double_field_6 as numeric)                                    as `2017`,

       cast(REGEXP_REPLACE(string_field_7, r"[^0-9.]", NULL) as numeric)  as `2016`,
       cast(REGEXP_REPLACE(string_field_8, r"[^0-9.]", NULL) as numeric)  as `2015`,
       cast(double_field_9 as numeric)                                    as `2014`,
       cast(REGEXP_REPLACE(string_field_10, r"[^0-9.]", NULL) as numeric) as `2013`,
       cast(REGEXP_REPLACE(string_field_11, r"[^0-9.]", NULL) as numeric) as `2012`,
       cast(REGEXP_REPLACE(string_field_12, r"[^0-9.]", NULL) as numeric) as `2011`,
       cast(REGEXP_REPLACE(string_field_13, r"[^0-9.]", NULL) as numeric) as `2010`,
       cast(REGEXP_REPLACE(string_field_14, r"[^0-9.]", NULL) as numeric) as `2009`,
       cast(REGEXP_REPLACE(string_field_15, r"[^0-9.]", NULL) as numeric) as `2008`,
       cast(REGEXP_REPLACE(string_field_16, r"[^0-9.]", NULL) as numeric) as `2007`,
       cast(REGEXP_REPLACE(string_field_17, r"[^0-9.]", NULL) as numeric) as `2006`,
       cast(REGEXP_REPLACE(string_field_18, r"[^0-9.]", NULL) as numeric) as `2005`,
       cast(REGEXP_REPLACE(string_field_19, r"[^0-9.]", NULL) as numeric) as `2004`,
       cast(REGEXP_REPLACE(string_field_20, r"[^0-9.]", NULL) as numeric) as `2003`,
       cast(REGEXP_REPLACE(string_field_21, r"[^0-9.]", NULL) as numeric) as `2002`,
       cast(REGEXP_REPLACE(string_field_22, r"[^0-9.]", NULL) as numeric) as `2001`,
       cast(REGEXP_REPLACE(string_field_23, r"[^0-9.]", NULL) as numeric) as `2000`
  from {{ source('staging','nama-10r-2gdp') }}
