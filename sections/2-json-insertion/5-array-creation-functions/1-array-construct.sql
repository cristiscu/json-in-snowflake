
-- ARRAY_CONSTRUCT
SELECT [1, 2, 3] arr, typeof(arr),
    array_construct(1, 2, 3) arr1, typeof(arr1),
    parse_json('[1, 2, 3]') arr2, typeof(arr2);

-- heterogenous array
SELECT array_construct(null, 1.2, 'string', false, object_construct('id', 123));

-- ARRAY_CONSTRUCT_COMPACT --> SQL NULLs are removed (not JSON nulls!)
SELECT array_construct(null, 1, 2, null, 3),
    array_construct_compact(null, 1, 2, null, 3);

-- ARRAY_GENERATE_RANGE
SELECT array_generate_range(1, 10),
    array_generate_range(1, 10, 2);
