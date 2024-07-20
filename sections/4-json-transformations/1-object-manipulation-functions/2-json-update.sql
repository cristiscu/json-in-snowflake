-- UPDATE JSON data (not in-place!)
-- see https://docs.snowflake.com/en/sql-reference/data-types-semistructured#label-data-type-object
use schema test.public;
select * from insert_json;

-- w/ explicit OBJECT construction
UPDATE insert_json
SET v = OBJECT_CONSTRUCT('Alberta', 'Edmonton', 'Manitoba', 'Winnipeg')
WHERE id = 1;
select * from insert_json;

-- w/ OBJECT constant
UPDATE insert_json
SET v = { 'Alberta': 'Edmonton' , 'Ontario': 'Ottawa' }
WHERE id = 1;
select * from insert_json;

-- w/ implicit parse of string to OBJECT
UPDATE insert_json
SET v = '{ "Alberta": "Edmonton" , "British Columbia": "Victoria" }'
WHERE id = 1;
select * from insert_json;

-- returns OBJECT, Edmonton, Edmonton, null
SELECT typeof(v), v:Alberta, v:"Alberta", v:alberta
FROM insert_json
WHERE id = 1;
