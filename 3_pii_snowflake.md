# Identifiy PII and Restrict Users in Snowflake
We have some ways of identifying the PII information, either we can use an external tool like a data catlog or we can write our own program in python or SQL

## Option 1: Creating Views -
a view can be used to eliminate pieces of data from the end user.
Columns may be eliminated by hidding them from the select and specific rows can be eliminated by implementing selective predicates.  

## Option 2: Row Level Security (RLS) - 

Row level security in Snowflake is implemented by using an ID field to identify specific rows, 
a mapping table to map those IDs to an identifiable attribute of the accessor (such as role being used).  
Best practice is to use the CURRENT_ROLE() or CURRENT_USER() functions to determine if a user should have access. 
A current_role can be searched to determine if the role name had PII or NON_PII in the naming convention to determine access.  

```
Example: 

where CURRENT_ROLE() not like ‘%NON_PII%’
```

## Option 3 Data Obfuscation - Masking Policy

Data can be obfuscated at run time in a view definition depending on certain parameters. 

```
For example, when selecting the field SSN one may implement:

CASE WHEN current_user() not in (select user_name from pii_enabled_users)
     THEN ‘XXX-XX-XXXX’
     ELSE SSN
END AS SSN
If the data within the field has an expected format, such as social security number, you could also implement a solution which returns a substring of the field.  It is important to note that this approach may expose unintended data if the data within the field is formatted differently than expected, such as if the SSN field contains dashes or not.  Example:

CASE WHEN current_user() not in (select user_name from pii_enabled_users)
     THEN substr(SSN, 8,11)
     ELSE SSN
END AS SSN
```

## Option 4: Object Segregation - Role based approach with permission to specific objects.

## Option 5: Secure Views - 
Secure views may be implemented along with solution 1, 2 or 3 to add an additional layer of security. 
With secure views the user will be unable to see the view definition. 
 
Options Mapped  

![image](https://user-images.githubusercontent.com/23280140/152233668-96cd4824-98bb-4dad-a83a-8e6a0548740a.png)

# Exmaple Use Case

Check which columns are ought to be masked or have PII information
Example column is **Username** in this case

Code 
```
---Check which Columns are to be masked---
select distinct  table_catalog, table_schema , table_name,column_name 
from "SNOWFLAKE"."ACCOUNT_USAGE"."COLUMNS" where column_name like '%Username%' 
```

## Option 3: Masking Aproach 

Create a Masking Policy for ACCOUNTADMIN role who can see the PII info otherwise it is hidden from others.

```
create or replace masking policy pii_mask as (val string) returns string ->
case when current_role() in  ('ACCOUNTADMIN') then val else sha2(val) end;
```


I have created a dynamic SQL to fetch the details then this SQL can be exceuted 

```
select distinct 'alter table ' || table_catalog || '.' || table_schema || '.' || table_name || ' modify column ' || column_name || ' set masking policy pii_mask ;'
from "SNOWFLAKE"."ACCOUNT_USAGE"."COLUMNS" where column_name like '%Username%' 
```


