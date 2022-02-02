with 
unioned as (
    {{ dbt_utils.union_relations(
        relations=[ref('ledger'), ref('ledger_2')]
    ) }}
 
),
 
renamed as (
    select      
        Book,
        Date as book_date,
        Trader,
        Instrument, -- used for the test
        Action as book_action,
        Cost,
        Currency,
        Volume,
        Cost_Per_Share,
        Stock_exchange_name
    from unioned 
)
 
select * from renamed
