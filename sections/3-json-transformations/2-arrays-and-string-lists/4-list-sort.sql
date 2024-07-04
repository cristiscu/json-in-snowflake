-- see https://stackoverflow.com/questions/69604547/list-sorting-in-snowflake-as-part-of-the-select?rq=3
use schema test.public;

-- (1) w/ JavaScript UDF
create or replace function sort_string(TEXT string)
    returns string
    language javascript
    strict immutable
as $$
    return TEXT.split('').sort().join('');
$$;

select sort_string(column1) sorted, count(*) count
from (values ('a'), ('b'), ('ab'), ('ba'))
group by 1;

-- (2) w/ CTE + LISTAGG + SPLIT_TO_TABLE + REGEX...
WITH cte AS (
    SELECT src.column1, sub.seq, 
        LISTAGG(sub.value) WITHIN GROUP(ORDER BY sub.value) AS sorted
    FROM (VALUES ('a'), ('b'), ('ab'), ('ba')) AS src,
        TABLE(SPLIT_TO_TABLE(TRIM(REGEXP_REPLACE(column1,'(.)', '\\1~'),'~'),'~')) AS sub
    GROUP BY src.column1, sub.seq)
SELECT sorted, COUNT(*) count
FROM cte
GROUP BY sorted;