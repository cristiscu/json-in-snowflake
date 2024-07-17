-- JSON ARRAY Manipulation Functions

-- get array info
select ARRAY_CONSTRUCT(2, 4, 6) arr,
    ARRAY_POSITION(4::variant, arr), 
    GET(arr, 1),
    ARRAY_SIZE(arr),
    ARRAY_MIN(arr),
    ARRAY_MAX(arr),
    ARRAY_CONTAINS(6, arr);

-- combine array elements
select ARRAY_CONSTRUCT(2, 4, null, 6, 4) arr1,
    ARRAY_CONSTRUCT(1, null, 2, 1) arr2,
	ARRAY_CAT(arr1, arr2),
    ARRAY_EXCEPT(arr1, arr2),
	ARRAY_INTERSECTION(arr1, arr2),
	ARRAYS_OVERLAP(arr1, arr2);

-- add array elements
select ARRAY_CONSTRUCT(2, 4, 6) arr,
    ARRAY_APPEND(arr, 8) arr_end,
    ARRAY_PREPEND(arr, 0) arr_start,
    ARRAY_INSERT(arr, 1, 3) arr_second;

-- remove array elements
select ARRAY_CONSTRUCT(2, 4, 6) arr,
    ARRAY_SLICE(arr, 1, 2),
    ARRAY_REMOVE(arr, 4),
    ARRAY_REMOVE_AT(arr, 1);

-- format array
select ARRAY_CONSTRUCT(2, 4, null, 6, 4) arr,
    ARRAY_COMPACT(arr),
    ARRAY_DISTINCT(arr),
    ARRAY_SORT(arr);

-- =========================================================
-- flatten array elements
select ARRAY_CONSTRUCT([2, [4], null], [6, 4]) arr,
    ARRAY_FLATTEN(arr),
    ARRAY_TO_STRING(arr, ',');

select ARRAY_CONSTRUCT([2, [4], null], [6, 4]) arr,
    f.value
from table(flatten(arr)) f;

select ARRAY_CONSTRUCT([2, [4], null], [6, 4]) arr,
    f1.value,
    f2.value
from table(flatten(arr)) f1,
    table(flatten(f1.value)) f2;
