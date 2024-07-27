-- with ARRAY_SIZE(ARRAY_UNIQUE_AGG(expr))
-- see https://docs.snowflake.com/en/user-guide/querying-arrays-for-distinct-counts
use schema SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000;

-- 34 seconds
SELECT ARRAY_UNIQUE_AGG(l_shipmode)
FROM lineitem;

-- 35 seconds
SELECT ARRAY_SIZE(ARRAY_UNIQUE_AGG(l_shipmode))
FROM lineitem;

-- 94 seconds
SELECT l_returnflag, l_discount,
    ARRAY_SIZE(ARRAY_UNIQUE_AGG(l_shipmode))
FROM lineitem
GROUP BY l_returnflag, l_discount;

-- 96 seconds
SELECT l_returnflag, l_discount,
    ARRAY_SIZE(ARRAY_UNIQUE_AGG(l_shipmode))
FROM lineitem
GROUP BY ROLLUP(l_returnflag, l_discount);
