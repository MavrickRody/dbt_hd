
  create or replace  view AQUILA_DEV.DBT_WPEER_JAFFLE_SHOP.test_macro_col_values  as (
    select 
    (Cost / 100)::numeric(16, 2)
 as CostA from AQUILA_DEV.DBT_WPEER_JAFFLE_SHOP.using_packaged_tests
  );
