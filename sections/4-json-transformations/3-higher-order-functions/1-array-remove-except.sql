-- Higher-order functions (FILTER + TRANSFORM)
-- see https://docs.snowflake.com/en/user-guide/querying-semistructured#label-higher-order-functions

-- ARRAY_REMOVE drops all elems, ARRAY_EXCEPT just a limited number
-- see https://stackoverflow.com/questions/68748322/array-remove-in-snowflake
select [2, 4, 4, 6, 4] arr,
    ARRAY_REMOVE(arr, 4),
    ARRAY_EXCEPT(arr, [4, 4, 1]);

-- FILTER (~ARRAY_REMOVE)
select [2, 4, 4, 6, 4] arr, FILTER(arr, elem int -> elem <> 4);

-- TRANSFORM (~inline update)
select [2, 4, 4, 6, 4] arr, TRANSFORM(arr, elem int -> elem * 2);
