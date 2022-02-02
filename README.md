# Architectural layout - dbt with snowflake
![image](https://user-images.githubusercontent.com/23280140/152135704-5300c5b8-bd4f-4200-9099-27ecc882972c.png)



# dbt_hd
A repo for dbt which includes test use cases.
```
install dbt cli 
```
follow the instructions from dbt website https://docs.getdbt.com/dbt-cli/install/overview
```
pip install dbt
```
# initialize project in dbt 
```
dbt init [projectname]
```
# change the project name in dbt_project.yml file
![image](https://user-images.githubusercontent.com/23280140/152115711-d8a1f9a2-dfe5-4b6b-84fd-f76ddb5d53cd.png)
![image](https://user-images.githubusercontent.com/23280140/152115732-b4f86254-06a4-49b4-b8f7-015c142c030e.png)

# configure your profile
![image](https://user-images.githubusercontent.com/23280140/152115061-5d479aea-9e78-4c5b-8282-43ed6ddee9d6.png)
#### When you invoke dbt from the command line, dbt parses your dbt_project.yml and obtains the **profile name**, which dbt needs to connect to your data warehouse.
Check the path to the profile file
```
dbt debug --config-dir
```
now configure the profile for snowflake with external browser asn SSO, there are other options but if you are the part of AD then SSO will work
```yml
dbt_snowflake:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: 
      user:   
      authenticator: externalbrowser
      role: 
      database: 
      warehouse: 
      schema: 
      threads: 2
      client_session_keep_alive: False
      query_tag: dbtqueries
```

# Load Data into Snowflake As Seeds

1. Create a new file in the data folder called ledger_1.csv
 Paste the following code in the file and save it.
```
Book,Date,Trader,Instrument,Action,Cost,Currency,Volume,Cost_Per_Share,Stock_exchange_name
B2020SW1,2021-03-03,Jeff A.,AAPL,BUY,-17420,GBP,200,87.1,NASDAQ
B2020SW1,2021-03-03,Jeff A.,AAPL,BUY,-320050,GBP,3700,86.5,NASDAQ
B2020SW1,2021-01-26,Jeff A.,AAPL,SELL,52500,GBP,-500,105,NASDAQ
B2020SW1,2021-01-22,Jeff A.,AAPL,BUY,-100940,GBP,980,103,NASDAQ
B2020SW1,2021-01-22,Nick Z.,AAPL,SELL,5150,GBP,-50,103,NASDAQ
B2020SW1,2019-08-31,Nick Z.,AAPL,BUY,-9800,GBP,100,98,NASDAQ
B2020SW1,2019-08-31,Nick Z.,AAPL,BUY,-1000,GBP,50,103,NASDAQ
```
3. Create another file ledger_2.csv in the data folder.
 Paste the following code in the file and save it.
```
Book,Date,Trader,Instrument,Action,Cost,Currency,Volume,Cost_Per_Share,Stock_exchange_name
B-EM1,2021-03-03,Tina M.,AAPL,BUY,-17420,EUR,200,87.1,NASDAQ
B-EM1,2021-03-03,Tina M.,AAPL,BUY,-320050,EUR,3700,86.5,NASDAQ
B-EM1,2021-01-22,Tina M.,AAPL,BUY,-100940,EUR,980,103,NASDAQ
B-EM1,2021-01-22,Tina M.,AAPL,BUY,-100940,EUR,980,103,NASDAQ
B-EM1,2019-08-31,Tina M.,AAPL,BUY,-9800,EUR,100,98,NASDAQ
```
4. Please run the dbt seed command to load the data into Snowflake
```
dbt seed
```

# Installation of Packages #dbtutils 

First step is to create the packages.yml file inside the project_hd directory

Second step : Include the following in your packages.yml file:
```
packages:
  - package: dbt-labs/dbt_utils
    version: 0.8.0
```    
Run dbt deps to install the package.

```
dbt deps

```


# Using Packages 

we will use the macro to union the seeded data
create a file using_packages_tests.sql file in model directory
```
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
        Instrument,
        Action as book_action,
        Cost,
        Currency,
        Volume,
        Cost_Per_Share,
        Stock_exchange_name
    from unioned 
)
 
select * from renamed

```

execute the model 
```
dbt run -m using_packaged_tests
```

# Creating Tables in Snowflake with Materialization
Create a file in hdmodel "table_Creation"
Paste the code 
#### Materialization- we can create tables or views in the databases

```
{{ config(materialized='table') }}
```
Code
```
{{ config(materialized='table') }}
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

```

or the other option is to mention it on the dbt_project.yml file

### table
```
models:
  dbt_hd:
    # Config indicated by + and applies to all files under models/example/
    example:
      +materialized: table

```
### view 
```
models:
  dbt_hd:
    # Config indicated by + and applies to all files under models/example/
    example:
      +materialized: view

```


# Testing the Models

For tests, dbt comes with a set of 4 pre-defined data tests:

uniqueness
not_null
check constraints
relationship integrity

1. Create a file called schema.yml in models\hdmodel

Place the below code to test the not_null on the instrument column

```

version: 2

models:
  - name: using_packaged_tests
    description: "A tester dbt model for HD"
    columns:
      - name: instrument
        tests:
          - not_null
```

Exceute the command dbt test 
this command will test all the models as we only have one so that would be tested.

```
dbt test 
```

result
![image](https://user-images.githubusercontent.com/23280140/152142567-2bb0426d-97d9-4e6d-8d67-d94d42ed219c.png)

we can use make functions from dbutils package

reference below:
https://hub.getdbt.com/dbt-labs/dbt_utils/0.1.7/


# using Macros 

Create a file cents_to_dollars.sql in marcos directory
and paste the code

```
{% macro cents_to_dollars(column_name, precision=2) %}
    ({{ column_name }} / 100)::numeric(16, {{ precision }})
{% endmacro %}
```

create another file in models directory

test_macro_col_values.sql
and paste the code

```
select {{ cents_to_dollars('Cost') }} as CostA from {{ref('using_packaged_tests')}}
```

### This will create a new view in snowflake with just one column but we can add more.


# Final Execution

Try running the following commands:
- dbt run
- dbt test



# CI & CD with dbt

First of all, we need to define the git workflow for the CI & CD
![image](https://user-images.githubusercontent.com/23280140/152223713-b49c4730-b854-48a4-8307-f0a4f4e39f6e.png)

When the code is merged with the main branch a pipeline in Azure DevOps get triggered

CI pipeline with the below code for publishing an artifact
yml file needs to be addded

```yml
trigger:
- main

pool:
  vmImage: ubuntu-latest

steps:
- task: PublishPipelineArtifact@1
  inputs:
    targetPath: '$(Pipeline.Workspace)'
    artifact: 'dbt_prod'
    publishLocation: 'pipeline'

```

# Create CD pipeline within Azure DevOps
Once the pipeline creates an Artifact, we can create another CD pipeline with the stages which will deploy the code on different databases or schemas.
we can use the variables in the profile file to change them with this pipelines.

![image](https://user-images.githubusercontent.com/23280140/152225116-2f59c679-51d7-45cd-ab5e-4c2c105001a5.png)

















