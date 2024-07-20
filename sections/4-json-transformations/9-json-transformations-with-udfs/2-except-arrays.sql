-- Return an array with the different values between two arrays
-- [a, b, c, d, e] + [a, f, c, g, e] --> [b, d, f, g]
-- see https://stackoverflow.com/questions/58634593/snowflake-return-different-not-similar-values-between-two-arrays
use schema test.public;

-- (1) w/ ARRAY_EXCEPT of ARRAY_INTERSECT
SELECT ['a', 'b', 'c', 'd', 'e'] arr1, ['a', 'f', 'c', 'g', 'e'] arr2,
    ARRAY_DISTINCT(ARRAY_CAT(arr1, arr2)) arrd,
    ARRAY_EXCEPT(arrd, ARRAY_INTERSECTION(arr1, arr2)) arre;

-- (2) w/ ARRAY_CAT of 2 x ARRAY_EXCEPT
SELECT ['a', 'b', 'c', 'd', 'e'] arr1, ['a', 'f', 'c', 'g', 'e'] arr2,
    ARRAY_EXCEPT(arr1, arr2) arr12, ARRAY_EXCEPT(arr2, arr1) arr21,
    ARRAY_CAT(arr12, arr21) arre;

-- ===============================================
-- (3) w/ JavaScript UDF
CREATE OR REPLACE FUNCTION except_arrays_js(arr1 ARRAY, arr2 ARRAY)
  RETURNS ARRAY
  LANGUAGE JAVASCRIPT
AS 'return [...ARR1.filter(e => !ARR2.includes(e)),...ARR2.filter(e => !ARR1.includes(e))]';

SELECT ['a', 'b', 'c', 'd', 'e'] arr1, ['a', 'f', 'c', 'g', 'e'] arr2,
    except_arrays_js(arr1, arr2) arre;

