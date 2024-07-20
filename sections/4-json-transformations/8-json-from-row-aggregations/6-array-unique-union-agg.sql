-- ARRAY_UNIQUE_AGG vs ARRAY_UNION_AGG

select arr,
    array_agg(elem.value) as array_agg,
    array_unique_agg(elem.value) as array_unique_agg,
    array_union_agg(elem.value) as array_union_agg
from (select [1, 2, 3, null, 2, 2] arr) t,
    table(flatten(t.arr)) elem
group by arr;

with cte(json) as (
    SELECT [1, null, 2, 1, 3],
    UNION ALL SELECT [null, 1, 2],
    UNION ALL SELECT [3, 2, 2],
    UNION ALL SELECT [3, 2, 2])
select array_agg(json) as array_agg,
    array_unique_agg(json) as array_unique_agg,
    array_union_agg(json) as array_union_agg
from cte;
