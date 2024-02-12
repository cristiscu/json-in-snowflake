-- show distinct aggregate array values
-- see https://stackoverflow.com/questions/60729360/how-to-combine-arrays-in-snowsql-groupby-and-only-keep-distinct-values
use schema test.public;

create or replace table submissions
AS SELECT submitter_id, split(markets,';') AS markets 
FROM VALUES (1, 'new york'), (1, 'new york;chicago') s(submitter_id, markets);
select * from submissions;

-- (1) w/ ARRAY_UNION_AGG
SELECT submitter_id, ARRAY_UNION_AGG(markets) AS markets
FROM submissions
GROUP BY submitter_id;

-- (2) w/ ARRAY_AGG + FLATTEN
with cte as (
    SELECT s.submitter_id, f.value AS market
    FROM submissions s, LATERAL FLATTEN(s.markets) f)
SELECT cte.submitter_id,
    ARRAY_AGG(DISTINCT cte.market) as markets
FROM cte
GROUP BY 1;