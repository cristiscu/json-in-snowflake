-- flatten multiple arrays
-- arr1     arr2        arr3        -->     
-- 1        11          101                 1, 11, 101
-- 2        12          102                 2, 12, 102
-- 3        13          103                 3, 13, 103
-- see https://stackoverflow.com/questions/69866984/flatten-snowflake-arrays-into-rows
use schema test.public;

-- (beware this will show array of strings no matter what in VSCode!)
CREATE OR REPLACE TABLE multi_arrays(arr1 array, arr2 array, arr3 array)
AS SELECT '[1, 2, 3]', '[11, 12, 13]', '[101, 102, 103]';
TABLE multi_arrays;

-- could also further filter by INDEX to get the Nth row
-- see https://stackoverflow.com/questions/64918384/getting-the-index-of-the-json-array-using-sql-in-snowflake
SELECT s1.value, s2.value, s3.value
FROM multi_arrays,
    TABLE(FLATTEN(multi_arrays.arr1)) s1,
    TABLE(FLATTEN(multi_arrays.arr2)) s2,
    TABLE(FLATTEN(multi_arrays.arr3)) s3
WHERE s1.index = s2.index AND s2.index = s3.index;