-- sort by count of all permutations
-- [ANN, BOB] (2), [ANN, BOB, CHRIS] (1)
-- https://stackoverflow.com/questions/66643770/how-can-you-sort-string-value-or-array-in-sql
use schema test.public;

create or replace table sort_string(id string, refs string)
as select * from values ('ID1', 'ANN,BOB'), ('ID2', 'BOB,ANN'), ('ID3', 'CHRIS,BOB,ANN');

-- LATERAL SPLIT_TO_TABLE --> flatten all string list values
SELECT d.id, trim(s.value) as name
FROM sort_string d, LATERAL SPLIT_TO_TABLE(d.refs, ',') s;

-- ARRAY_AGG w/ WITHIN GROUP and PARTITION BY
SELECT names, count(distinct(id)) as count
FROM (
  SELECT ARRAY_AGG(name) WITHIN GROUP (ORDER BY name) OVER (PARTITION BY id) as names, id
  FROM (
    SELECT d.id, trim(s.value) as name
    FROM sort_string d, LATERAL SPLIT_TO_TABLE(d.refs, ',') s))
GROUP BY 1 ORDER BY 1;
