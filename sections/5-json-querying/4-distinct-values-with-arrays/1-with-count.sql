-- with COUNT(DISTINCT expr)
use schema SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000;

-- 51 seconds
SELECT DISTINCT l_shipmode
FROM lineitem;

-- 11 seconds (micro-partition! great pruning!)
SELECT COUNT(DISTINCT l_shipmode)
FROM lineitem;

-- 92 seconds
SELECT l_returnflag, l_discount,
    COUNT(DISTINCT l_shipmode)
FROM lineitem
GROUP BY l_returnflag, l_discount;

-- 206 seconds
SELECT l_returnflag, l_discount,
    COUNT(DISTINCT l_shipmode)
FROM lineitem
GROUP BY ROLLUP(l_returnflag, l_discount);
