-- ARRAY_AGG vs LISTAGG
use schema test.public;

CREATE OR REPLACE TABLE listaggs(id int, json array, str text)
AS SELECT 1, [1, null, 2, 1, 3], '1,null,2,1,3'
    UNION ALL SELECT 1, [null, 1, 2], 'null,1,2'
    UNION ALL SELECT 2, [3, 2, 2], '3,2,2'
    UNION ALL SELECT 2, [3, 2, 2], '3,2,2';
table listaggs;

select array_agg(json), listagg(str, ',')
from listaggs;

select array_agg(distinct json), listagg(distinct str, ',')
from listaggs;

select array_agg(distinct json) arr,
    array_distinct(array_compact(array_flatten(arr))) arr2,
    listagg(distinct str, ',') lst,
    array_to_string(array_distinct(array_remove(strtok_to_array(lst, ','), 'null'::variant)), ',') lst2
from listaggs;
