-- Join books with tags
-- see https://stackoverflow.com/questions/63034975/how-to-join-array-with-string-in-snowflake
use schema test.public;

create or replace table books1(title string, tag_ids array)
as select $1, parse_json($2) from values
    ('Moby Dick', '["good", "adventure", "drama"]'),
    ('Bandits', '["good"]'),
    ('Sara', '["bad", "drama"]'),
    ('Margot', '["fine", "interesting"]');

create or replace table tags1(id int, tag_id varchar)
as select * from values
    (1, 'good'),
    (2, 'bad'), 
    (3, 'drama'), 
    (4, 'sf'), 
    (5, 'romance');

/*
Desired Output:

TITLE	    TAG_IDS	                        ID	TAG_ID
-------------------------------------------------------
Bandits	    ["good"]	                    1	good
Moby Dick	["good","adventure","drama"]	3	drama
Moby Dick	["good","adventure","drama"]	1	good
Sara	    ["bad","drama"]	                2	bad
Sara	    ["bad","drama"]	                3	drama
*/

-- w/ ARRAY_CONTAINS
select *
from books1 b
    inner join tags1 t
    on ARRAY_CONTAINS(tag_id::variant, tag_ids)
order by b.title, t.tag_id;

-- FLATTEN + JOIN
select b.*, t.*
from books1 b
    inner join lateral flatten(b.tag_ids) bt
    inner join tags1 t on bt.value = t.tag_id
order by b.title, t.tag_id;
