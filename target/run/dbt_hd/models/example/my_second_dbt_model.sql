
  create or replace  view AQUILA_DEV.DBT_WPEER_JAFFLE_SHOP.my_second_dbt_model  as (
    -- Use the `ref` function to select from other models

select *
from AQUILA_DEV.DBT_WPEER_JAFFLE_SHOP.my_first_dbt_model
where id = 1
  );
