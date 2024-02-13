-- must return a list of region names: 'EAME, LA, NA, NAP, SAP'
-- see https://stackoverflow.com/questions/70671029/snowflake-array-to-string-issue

with cte as (
    select parse_json($1) v from values
    ('[{"region": "EAME"}, {"region": "LA"}, {"region": "NA"}, {"region": "NAP"}, {"region": "SAP"}]'))
SELECT LISTAGG(f.value:region::string, ', ') AS regions
FROM cte, LATERAL FLATTEN(v) f;
