-- filter by array constraint (instead of value IN (...))
-- see https://stackoverflow.com/questions/68597737/convert-an-array-of-strings-to-an-array-of-numbers-in-snowflake

-- row generator 1..10
select row_number() over(order by 1) as rn
from table(generator(rowcount => 10));

-- false, true
select array_contains(2::varchar::variant, SPLIT('1,4,32', ','));
select array_contains(4::varchar::variant, SPLIT('1,4,32', ','));

-- (1) w/ ARRAY_CONTAINS
-- returns only 1 and 4
select row_number() over(order by 1) as rn
from table(generator(rowcount => 10))
qualify ARRAY_CONTAINS(rn::varchar::variant, SPLIT('1,4,32', ','));

-- (2) w/ STRTOK_SPLIT_TO_TABLE and IN
SELECT rn FROM (
    select row_number() over(order by 1) as rn
    from table(generator(rowcount => 10)))
WHERE rn IN (
    SELECT s.value::INT 
    FROM TABLE(STRTOK_SPLIT_TO_TABLE('1,4,32', ',')) s);

-- (3) w/ STRTOK_SPLIT_TO_TABLE and JOIN
with cte as (
    select row_number() over(order by 1) as rn
    from table(generator(rowcount => 10))),
arr as (SELECT s.value::INT value
    FROM TABLE(STRTOK_SPLIT_TO_TABLE('1,4,32', ',')) s)
SELECT cte.rn FROM cte JOIN arr ON cte.rn = arr.value;

