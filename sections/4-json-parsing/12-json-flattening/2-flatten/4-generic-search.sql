-- see https://stackoverflow.com/questions/65653451/snowflake-how-to-search-for-a-value-in-json-values-without-using-hardcoded-keys
use schema test.public;

create or replace table variants as (
    select 1 id, parse_json('{"d1":1, "d2":2, "d3":3}') data
    union all select 2, parse_json('{"d1":4, "d2":5, "d3":7}') 
    union all select 3, parse_json('{"d1":2, "d2":0, "d3":0}'));

select *
from variants, table(flatten(data));

select id, not boolor_agg((iff(key like 'd%', value=2, true))) cond
from variants, table(flatten(data))
group by id;

select id, boolor_agg(value=2) 
from variants, table(flatten(data))
where key like 'd%'
group by id;
