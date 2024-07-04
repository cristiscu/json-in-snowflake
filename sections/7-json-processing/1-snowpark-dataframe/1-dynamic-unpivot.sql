-- Dynamic UNPIVOT (or MELT)
-- a b  c       --> key     value
-- 1 10 0.1         a       1
-- 2 11 0.12        a       2
-- 3 12 0.13        a       3
--                  b       10
--                  ...
--                  c       0.13
-- see https://stackoverflow.com/questions/68553105/is-there-a-melt-command-in-snowflake
-- see https://stackoverflow.com/questions/66425756/snowflake-how-can-we-run-an-unpivot-query-over-an-array-of-fields-instead-of-exp/75987369#75987369
USE SCHEMA test.public;

CREATE OR REPLACE TABLE melt(a INT, b INT, c DECIMAL(10,2)) AS
    SELECT 1, 10, 0.1
    UNION SELECT 2, 11, 0.12
    UNION SELECT 3, 12, 0.13;
SELECT * from melt;

-- (1) w/ FLATTEN + OBJECT_CONSTRUCT_KEEP_NULL
-- transforms rows into JSON --> { a: 1, b: 10, c: 0.1 } ...
SELECT OBJECT_CONSTRUCT_KEEP_NULL(*) AS json
FROM melt;

-- parse the JSON into key-value pairs
WITH cte AS (
    SELECT OBJECT_CONSTRUCT_KEEP_NULL(*) AS json
    FROM melt)
SELECT f.key, f.value
FROM cte, TABLE(FLATTEN(cte.json)) f
ORDER BY f.key;

-- (2) w/ Python stored proc
CREATE OR REPLACE PROCEDURE melt_python(
    tablename TEXT, ids ARRAY, vals ARRAY)
    RETURNS TABLE()
    LANGUAGE PYTHON
    RUNTIME_VERSION = 3.9
    PACKAGES = ('snowflake-snowpark-python')
    HANDLER = 'main'
AS $$
import snowflake.snowpark as snowpark
def main(session: snowpark.Session,
    tablename: str, ids: list, vals: list): 
    return (session
        .create_dataframe(session
            .table(tablename)
            .to_pandas()
            .melt(ids, vals)))
$$;

CALL melt_python('MELT', [], ['A', 'B', 'C']);

-- (3) UNPIVOT all w/ Python stored proc
CREATE OR REPLACE PROCEDURE unpivot_all(tablename TEXT)
    RETURNS TABLE()
    LANGUAGE PYTHON
    RUNTIME_VERSION = 3.9
    PACKAGES = ('snowflake-snowpark-python')
    HANDLER = 'main'
AS $$
import snowflake.snowpark as snowpark
def main(session: snowpark.Session, tablename: str): 
    df = session.table(tablename)
    return df.unpivot("key", "value", df.columns)
$$;

-- must use C with similar data type!
CALL unpivot_all('MELT');