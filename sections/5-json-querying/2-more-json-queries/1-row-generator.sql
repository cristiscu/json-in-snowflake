-- row generator 1..N

-- (1) w/ ROW_NUMBER + GENERATOR
select ROW_NUMBER() over(order by 1) as rn
from table(generator(rowcount => 10));

-- (2) w/ ARRAY_GENERATE_RANGE + FLATTEN
select value::int rn
from (select ARRAY_GENERATE_RANGE(1, 11) arr),
    table(flatten(arr));

with cte as (select ARRAY_GENERATE_RANGE(1, 11) arr)
select value::int rn
from cte, table(flatten(arr));
