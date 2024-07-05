use schema test.public;

CREATE OR REPLACE TABLE listaggs(id int, json array, str text) AS
SELECT 1, parse_json('[1, null, 2, 1, 3]'), '1,null,2,1,3'
UNION ALL SELECT 1, parse_json('[null, 1, 2]'), 'null,1,2'
UNION ALL SELECT 2, parse_json('[3, 2, 2]'), '3,2,2'
UNION ALL SELECT 2, parse_json('[3, 2, 2]'), '3,2,2';
table listaggs;

select array_agg(json), listagg(str, ',')
from listaggs;

select array_agg(distinct json), listagg(distinct str, ',')
from listaggs;

select array_flatten(array_agg(distinct json)) a,
    listagg(distinct str, ',') b,
    strtok_to_array(listagg(distinct str, ','), ',') c
from listaggs;

select array_agg(json),
    array_unique_agg(json),
    array_union_agg(json)
from listaggs;
