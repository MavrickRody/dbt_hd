
with 
unioned as (
    

        (
            select

                cast('AQUILA_DEV.DBT_WPEER_JAFFLE_SHOP.ledger' as 
    varchar
) as _dbt_source_relation,
                
                    cast("BOOK" as character varying(16777216)) as "BOOK" ,
                    cast("DATE" as DATE) as "DATE" ,
                    cast("TRADER" as character varying(16777216)) as "TRADER" ,
                    cast("INSTRUMENT" as character varying(16777216)) as "INSTRUMENT" ,
                    cast("ACTION" as character varying(16777216)) as "ACTION" ,
                    cast("COST" as NUMBER(38,0)) as "COST" ,
                    cast("CURRENCY" as character varying(16777216)) as "CURRENCY" ,
                    cast("VOLUME" as NUMBER(38,0)) as "VOLUME" ,
                    cast("COST_PER_SHARE" as FLOAT) as "COST_PER_SHARE" ,
                    cast("STOCK_EXCHANGE_NAME" as character varying(16777216)) as "STOCK_EXCHANGE_NAME" 

            from AQUILA_DEV.DBT_WPEER_JAFFLE_SHOP.ledger
        )

        union all
        

        (
            select

                cast('AQUILA_DEV.DBT_WPEER_JAFFLE_SHOP.ledger_2' as 
    varchar
) as _dbt_source_relation,
                
                    cast("BOOK" as character varying(16777216)) as "BOOK" ,
                    cast("DATE" as DATE) as "DATE" ,
                    cast("TRADER" as character varying(16777216)) as "TRADER" ,
                    cast("INSTRUMENT" as character varying(16777216)) as "INSTRUMENT" ,
                    cast("ACTION" as character varying(16777216)) as "ACTION" ,
                    cast("COST" as NUMBER(38,0)) as "COST" ,
                    cast("CURRENCY" as character varying(16777216)) as "CURRENCY" ,
                    cast("VOLUME" as NUMBER(38,0)) as "VOLUME" ,
                    cast("COST_PER_SHARE" as FLOAT) as "COST_PER_SHARE" ,
                    cast("STOCK_EXCHANGE_NAME" as character varying(16777216)) as "STOCK_EXCHANGE_NAME" 

            from AQUILA_DEV.DBT_WPEER_JAFFLE_SHOP.ledger_2
        )

        
 
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