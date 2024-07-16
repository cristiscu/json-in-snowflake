
-- TO/AS/IS_ARRAY
select
    to_variant('[1, 2, 3]') var, typeof(var), is_array(var),
    to_array(var) arr1, typeof(arr1), is_array(arr1),
    as_array(parse_json(var)) arr2, typeof(arr2), is_array(arr2);

-- not ok
SELECT '[1, 2, 3]' arr, typeof(arr);

CREATE OR REPLACE TABLE test.public.arrays1(
    arr1 array, arr2 variant, arr3 variant, arr4 variant)
AS SELECT '[1, 2, 3]', '[1, 2, 3]',
    array_construct(1, 2, 3), parse_json('[1, 2, 3]');

-- all ARRAY!
SELECT arr1, typeof($1),
    arr2, typeof(arr2),
    arr3, typeof(arr3),
    arr4, typeof(arr3)
FROM test.public.arrays1;
