-- SUM all array values
-- see https://stackoverflow.com/questions/52034078/summing-values-from-a-json-array-in-snowflake

with cte as (
    select parse_json($$ [
        [ "source 1", 250 ],
        [ "other source", 58 ],
        [ "more stuff", 42 ]
    ] $$) as v)
select sum(value[1])
from cte, table(flatten(v));