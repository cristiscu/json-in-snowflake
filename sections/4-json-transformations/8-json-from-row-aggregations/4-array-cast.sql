-- Convert array of strings to array of numbers
-- ["1", "2", "3"] --> [1, 2, 3]
-- see https://stackoverflow.com/questions/74985280/convert-array-of-strings-to-array-of-integer-snowflake

-- (1) w/ structured data ARRAY cast
SELECT arr, arr::array(int) AS arri
FROM (SELECT ['1', '2', '3'] arr);

-- (2) w/ ARRAY_AGG
SELECT arr, ARRAY_AGG(TRY_CAST(f.value::text AS INT)) AS arri
FROM (SELECT ['1', '2', '3'] arr) t, TABLE(FLATTEN(t.arr)) AS f
GROUP BY arr;

-- (3) w/ higher-order function TRANSFORM
SELECT arr, TRANSFORM(arr, elem text -> elem::int) AS arri
FROM (SELECT ['1', '2', '3'] arr);
