select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

select *
from AQUILA_DEV.DBT_WPEER_JAFFLE_SHOP.my_first_dbt_model
where id is null



      
    ) dbt_internal_test