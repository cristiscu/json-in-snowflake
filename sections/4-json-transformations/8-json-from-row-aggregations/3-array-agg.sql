-- ARRAY_AGG
-- see https://docs.snowflake.com/en/sql-reference/functions/array_agg
use schema test.public;

-- generate row numbers w/ 1, 2, 3.. 5
create or replace view gen5_array
as select
  row_number() over(order by 1) as value,
  value % 2 as odd
from table(generator(rowcount => 5));
select * from gen5_array;

-- ARRAY_AGG
select array_agg(value)
from gen5_array;

select array_agg(DISTINCT value) WITHIN GROUP(ORDER BY odd)
from gen5_array;

select array_agg(value) over (partition by odd)
from gen5_array;
