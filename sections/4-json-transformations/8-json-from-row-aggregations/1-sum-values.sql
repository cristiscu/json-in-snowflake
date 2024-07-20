-- SUM all ARRAY values
-- see https://stackoverflow.com/questions/52034078/summing-values-from-a-json-array-in-snowflake

with cte as (select [
    ['John', 250],
    ['Bill', 58],
    ['Jane', 42]] v)
select sum(value[1])
from cte, table(flatten(v));

with cte as (select [
    {'name':'John', 'sales':250},
    {'name':'Bill', 'sales':58},
    {'name':'Jane', 'sales':42}] v)
select sum(value:sales)
from cte, table(flatten(v));
