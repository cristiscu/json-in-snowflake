-- show distinct aggregate array values
-- see https://stackoverflow.com/questions/60729360/how-to-combine-arrays-in-snowsql-groupby-and-only-keep-distinct-values
use schema test.public;

create or replace table submissions as
SELECT id, split(markets,';') AS markets
FROM VALUES (1, 'new york'), (1, 'new york;chicago'), (2, 'chicago;detroit') s(id, markets);
select * from submissions;

-- (1) w/ ARRAY_AGG + FLATTEN
with cte as (
    SELECT s.id, f.value AS market
    FROM submissions s, LATERAL FLATTEN(s.markets) f)
SELECT cte.id, ARRAY_AGG(DISTINCT cte.market) as markets
FROM cte
GROUP BY 1;

-- (2) w/ ARRAY_AGG+ARRAY_FLATTEN+ARRAG_DISTINCT + FLATTEN
SELECT id, ARRAY_DISTINCT(ARRAY_FLATTEN(ARRAY_AGG(DISTINCT markets))) AS markets
FROM submissions, TABLE(FLATTEN(markets)) f
GROUP BY 1;

-- (3) w/ ARRAY_UNION_AGG (no FLATTEN)
SELECT id, ARRAY_UNION_AGG(markets) AS markets
FROM submissions
GROUP BY 1;

-- (4) w/ ARRAY_UNION_AGG (no FLATTEN) and CASE WHEN filter to hide
-- see https://stackoverflow.com/questions/56653489/how-do-i-use-array-agg-with-a-condition
SELECT id, ARRAY_UNION_AGG(case when id <> 2 then markets end) AS markets
FROM submissions
GROUP BY 1;
