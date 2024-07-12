-- array creation
use schema test.public;

SELECT '[1, 2, 3]', array_construct(1, 2, 3), parse_json('[1, 2, 3]');

CREATE OR REPLACE TABLE arrays1(arr1 array, arr2 variant, arr3 variant)
AS SELECT '[1, 2, 3]', array_construct(1, 2, 3), parse_json('[1, 2, 3]');
SELECT * FROM arrays1;

-- all ARRAY!
SELECT typeof($1), typeof(arr2), typeof(arr3)
FROM arrays1;
