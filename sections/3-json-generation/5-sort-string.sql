-- https://stackoverflow.com/questions/66643770/how-can-you-sort-string-value-or-array-in-sql
use schema test.public;

create or replace table sort_string(id string, refs string)
as SELECT * FROM VALUES
('ID1', 'ANN,BOB'), ('ID2', 'BOB,ANN'), ('ID3', 'CHRIS,BOB,ANN');

-- (1)
SELECT order_arry, count(distinct(id)) as count
FROM (
  SELECT array_agg(val) WITHIN GROUP (ORDER BY val) over (partition by id) as order_arry, id
  FROM (
    SELECT d.id, trim(s.value) as val
    FROM sort_string d, lateral split_to_table(d.refs, ',') s))
GROUP BY 1 ORDER BY 1;

-- (2)
SELECT ordered_arry, count(id) as count 
FROM (
  SELECT id, array_agg(val) WITHIN GROUP (ORDER BY val) as ordered_arry
  FROM (
    SELECT d.id, trim(s.value) as val
    FROM sort_string d, lateral split_to_table(d.refs, ',') s)
  GROUP BY 1)
GROUP BY 1 ORDER BY 1;