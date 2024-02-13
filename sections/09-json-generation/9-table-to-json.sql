-- convert all tables rows to JSON
-- see https://stackoverflow.com/questions/71864782/snowflake-convert-an-entire-table-to-json

/*
Initial Output:
ColA    ColB    ColC
1       b1      c1
...
Desired Output:
{
  "[1]": { "ColB ": "b1", "ColC ": "c1" },
  ...
}
*/

use schema test.public;

create or replace table col123(colA int, colB string, colC string);
insert into col123 values (1, 'b1', 'c1'), (2, 'b2', 'c2'), (3, 'b3', 'c3');

select colA, object_construct('ColB', colB, 'ColC', colC) as v from col123;

select OBJECT_AGG(colA, object_construct('ColB', colB, 'ColC', colC)) as v from col123;
