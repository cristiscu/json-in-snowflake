-- array of string to array of numbers
-- ["1", "2", "3"] --> [1, 2, 3]
-- see https://stackoverflow.com/questions/74985280/convert-array-of-strings-to-array-of-integer-snowflake
use schema test.public;

CREATE OR REPLACE TABLE array_str
AS SELECT parse_json('["1", "2", "3"]') arr;
select typeof($1) from array_str;

-- (beware this will show array of strings no matter what in VSCode!)
SELECT arr, ARRAY_AGG(TRY_CAST(f.value::text AS INT)) AS arri
FROM array_str, TABLE(FLATTEN(array_str.arr)) AS f
GROUP BY arr;

-- w/ higher function TRANSFORM
SELECT arr, transform(arr, elem text -> elem::int) AS arri
FROM array_str;