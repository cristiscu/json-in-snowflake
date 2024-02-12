-- row generator 1..N

-- (1) w/ ROW_NUMBER + GENERATOR
select row_number() over(order by 1) as rn
from table(generator(rowcount => 10));

-- (2) w/ ARRAY_GENERATE_RANGE + FLATTEN
with cte as (select ARRAY_GENERATE_RANGE(1, 11) rn)
select f.value::int rn
FROM cte, TABLE(FLATTEN(cte.rn)) f;
