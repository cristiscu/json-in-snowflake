-- OBJECT_AGG
-- see https://docs.snowflake.com/en/sql-reference/functions/object_agg
use schema test.public;

-- generate row numbers w/ 1, 2, 3.. 5
create or replace view gen5_object
as select
  row_number() over(order by 1) as value,
  'key' || value as key,
  value % 2 as odd
from table(generator(rowcount => 5));
select * from gen5_object;

-- OBJECT_AGG
select object_agg(key, value)
from gen5_object;

select object_agg(key, value) over (partition by odd)
from gen5_object;
