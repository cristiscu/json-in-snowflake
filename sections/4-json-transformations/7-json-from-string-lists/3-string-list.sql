-- Break string list values into rows --> STRTOK_TO_ARRAY
-- see https://stackoverflow.com/questions/69676196/break-json-list-of-values-into-rows-in-a-snowflake-database-table

/*
Initial Table:
NAME        GENDER      ORDERS          CITY
------------------------------------------------
A           M           ["completed"]   ["Cochi,Hyderabad"]
B           M           ["completed"]   ["Cochi,Hyderabad,Delhi"]
C           F           ["cancelled"]   ["Mumbai,Pune"]
D           M           ["pending"]     ["Cochi"]

Desired Output:
NAME        GENDER      ORDERS          CITY
------------------------------------------------
A           M           completed       Cochi
A           M           completed       Hyderabad
B           M           completed       Cochi
B           M           completed       Hyderabad
B           M           completed       Delhi
C           F           cancelled       Mumbai
C           F           cancelled       Pune
D           M           pending         Cochi
*/

-- (1) w/ 1x FLATTEN + STRTOK_TO_ARRAY and no JSON initially
with cte1(name, gender, orders, city) as (
    select 'A', 'M', '["completed"]', '["Cochi,Hyderabad"]'
    union all select 'B', 'M', '["completed"]', '["Cochi,Hyderabad,Delhi"]'
    union all select 'C', 'F', '["cancelled"]', '["Mumbai,Pune"]'
    union all select 'D', 'M', '["pending"]', '["cochi"]'),
cte2 as (
    select name, gender,
        replace(replace(orders, '["', ''), '"]', '') as orders,
        STRTOK_TO_ARRAY(replace(replace(city, '["', ''), '"]', ''), ',') as city
    from cte1)
select name, gender, orders, replace(c.value, '"', '') as city
from cte2, lateral flatten(city) c;

-- (2) w/ 2x FLATTEN + STRTOK_TO_ARRAY and JSON initially
with cte1(name, gender, orders, city) as (
    select 'A', 'M', ['completed'], ['Cochi,Hyderabad']
    union all select 'B', 'M', ['completed'], ['Cochi,Hyderabad,Delhi']
    union all select 'C', 'F', ['cancelled'], ['Mumbai,Pune']
    union all select 'D', 'M', ['pending'], ['cochi'])
select name, gender,
    orders.value::varchar orders,
    city.value::varchar city
from cte1,
    lateral flatten(orders) orders,
    lateral flatten(city) city_raw,
    lateral flatten(STRTOK_TO_ARRAY(city_raw.value, ', ')) city;
