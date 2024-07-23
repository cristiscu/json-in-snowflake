-- Typical aggregates on flattened JSON array
-- see https://stackoverflow.com/questions/72872414/flatten-nested-array-and-aggregate-in-snowflake

use schema test.public;

CREATE OR REPLACE TABLE Data(ID int, PROJ variant, LOCATION string)
    AS SELECT    1, [[0, 4], [1, 30], [10, 20]],    'S'
    UNION SELECT 2, [[0, 2], [1, 20]],              'S'
    UNION SELECT 3, [[0, 8], [1, 10], [10, 100]],   'S';

/*
Desired Output:

INDEX	LOCATION	MIN	    MAX	    MEAN
0	    S	        2	    8	    4.666667
1	    S	        10	    30	    20
10	    S	        20	    100	    60
*/

SELECT s.VALUE[0]::INT AS Index,
    MAX(LOCATION) AS Location,
    MIN(s.VALUE[1]::INT) AS Min,
    MAX(s.VALUE[1]::INT) AS Max,
    AVG(s.VALUE[1]::INT) AS Mean
FROM DATA, LATERAL FLATTEN(PROJ) s
GROUP BY s.VALUE[0]::INT
ORDER BY Index;