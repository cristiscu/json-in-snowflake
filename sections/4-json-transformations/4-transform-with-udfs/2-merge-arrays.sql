-- Merge two arrays and keep only distinct values
-- [a, b] + [a, c] --> [a, b, c]
-- see https://stackoverflow.com/questions/70290286/how-to-concatenate-arrays-in-snowflake-with-distinct-values
-- see https://stackoverflow.com/questions/74030546/pass-array-to-snowflake-udf
use schema test.public;

-- (1) w/ ARRAY_DISTINCT
SELECT ARRAY_DISTINCT(
    ARRAY_CAT(
        ARRAY_CONSTRUCT('a', 'b'),
        ARRAY_CONSTRUCT('a', 'c'))) arrd;

-- (2) w/ ARRAY_AGG after FLATTEN
SELECT ARRAY_AGG(DISTINCT F.value) AS arrd
FROM TABLE(FLATTEN(
    ARRAY_CAT(
        ARRAY_CONSTRUCT('a', 'b'), 
        ARRAY_CONSTRUCT('a', 'c')))) f;

-- (3) w/ JavaScript UDF
create or replace function remove_dups_js(arr1 variant, arr2 variant)
    returns variant
    language javascript
as 'return Array.from(new Set([...ARR1, ...ARR2]))';

SELECT remove_dups_js(
    ARRAY_CONSTRUCT('a', 'b'),
    ARRAY_CONSTRUCT('a', 'c')) arrd;

-- (4) w/ Python UDF
create or replace function remove_dups(arr array)
    returns array
    language python
    runtime_version = '3.9'
    handler = 'x'
as $$
def x(arr):
    return list(set(arr))
$$;

SELECT ARRAY_SORT(
    remove_dups(
        ARRAY_CAT(
            ARRAY_CONSTRUCT('a', 'b'),
            ARRAY_CONSTRUCT('a', 'c')))) arrd;

-- (4) FILTER/TRANSFORM? TODO