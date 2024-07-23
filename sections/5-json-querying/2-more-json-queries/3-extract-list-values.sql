-- Return a list of region names from string list: 'EAME, LA, NA, NAP, SAP'
-- see https://stackoverflow.com/questions/70671029/snowflake-array-to-string-issue

set list = '[{"region": "EAME"}, {"region": "LA"}, {"region": "NA"}, {"region": "NAP"}, {"region": "SAP"}]';

/*
Desired Output:

REGIONS
------------------------
EAME, LA, NA, NAP, SAP
*/

with cte as (select parse_json($1) v from values ($list))
SELECT LISTAGG(f.value:region::string, ', ') AS regions
FROM cte, LATERAL FLATTEN(v) f;
