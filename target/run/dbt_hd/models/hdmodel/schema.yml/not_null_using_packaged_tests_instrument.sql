select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

select *
from AQUILA_DEV.DBT_WPEER_JAFFLE_SHOP.using_packaged_tests
where instrument is null



      
    ) dbt_internal_test