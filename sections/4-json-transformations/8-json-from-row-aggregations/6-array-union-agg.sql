-- get DISTINCT vals from two arrays
-- see https://stackoverflow.com/questions/63160349/flatten-and-aggregate-two-columns-of-arrays-via-distinct-in-snowflake

/*
Initial Table
  Animals      |  Herbs  
---------------+---------
 [Cat, Dog]    | [Basil] 
 [Dog, Lion]   | []      

Desired output: [Cat, Dog, Lion, Basil]
*/

use schema test.public;

CREATE OR REPLACE TABLE arrays2 AS
    SELECT ['Cat', 'Dog'] AS Animals, ['Basil'] AS Herbs
    UNION SELECT ['Dog', 'Lion'], [];

-- (1) w/ ARRAY_UNION_AGG + ARRAY_CAT
SELECT ARRAY_UNION_AGG(ARRAY_CAT(Animals, Herbs)) AS res
FROM arrays2;

-- (2) w/ ARRAY_UNION_AGG from the two columns
SELECT ARRAY_UNION_AGG(Animals) AS res
FROM (SELECT Animals FROM arrays2
      UNION ALL SELECT Herbs FROM arrays2);

-- (3) w/ ARRAY_AGG, ARRAY_CAT, FLATTEN
SELECT ARRAY_AGG(DISTINCT F."VALUE") AS res
FROM arrays2, TABLE(FLATTEN(ARRAY_CAT(Animals, Herbs))) f;

-- (4) w/ ARRAY_AGG + UNION subqueries
select ARRAY_AGG(DISTINCT value) res
from (
    select value from arrays2, lateral flatten(Animals)
    union all
    select value from arrays2, lateral flatten(Herbs));

