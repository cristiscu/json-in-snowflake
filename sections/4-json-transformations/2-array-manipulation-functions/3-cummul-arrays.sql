-- cumulatively combine arrays from previous rows into one aggregate array with unique values
-- see https://stackoverflow.com/questions/70864833/how-to-cumulatively-combine-arrays-from-previous-rows-into-one-aggregate-array
USE SCHEMA test.public;

/*
Expected Output:

ID          ITEMS           ITEMS_AGG
-------+---------------+-------------------
1           [a, b]          [a, b]
2           [a, c]          [a, b, c]
3           [b, c]          [a, b, c]
4           [a, d]          [a, b, c, d]
5           [a, b, e]       [a, b, c, d, e]
*/

-- (1) With Table + Query
CREATE OR REPLACE TABLE cummul_arrays AS
    SELECT $1 AS id, SPLIT($2, ',') AS items
    FROM VALUES (1, 'a,b'), (2, 'a,c'), (3, 'b,c'), (4, 'a,d'), (5, 'a,b,e');

WITH RECURSIVE cte AS (
    SELECT id, items, items AS items_agg
    FROM cummul_arrays WHERE id = 1
    UNION ALL
    SELECT cte.id + 1 AS id, d.items,
        ARRAY_DISTINCT(ARRAY_CAT(cte.items_agg, d.items)) AS items_agg
    FROM cte JOIN cummul_arrays d ON cte.id + 1 = d.id
    ORDER BY id)
SELECT * from cte;

-- (2) With Dynamic Query
WITH data AS (
    SELECT $1 AS id, SPLIT($2, ',') AS items
    FROM VALUES (1, 'a,b'), (2, 'a,c'), (3, 'b,c'), (4, 'a,d'), (5, 'a,b,e')),
rec AS (
    WITH RECURSIVE cte AS (
        SELECT id, items, items AS items_agg
        FROM data WHERE id = 1
        UNION ALL
        SELECT cte.id + 1 AS id, d.items,
            ARRAY_DISTINCT(ARRAY_CAT(cte.items_agg, d.items)) AS items_agg
        FROM cte JOIN data d ON cte.id + 1 = d.id
        ORDER BY id
    )
    SELECT * from cte)
SELECT * FROM rec;
