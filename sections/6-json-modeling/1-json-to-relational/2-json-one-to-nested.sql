-- JSON w/ two-level nested OBJECTs
use schema test.public;

-- each JSON data has an OBJECT w/ a nested OBJECT (no ARRAYs)
create or replace table sales_json (id int, v variant) as 
select row_number() over (order by 1), parse_json($1)
from values 
    ('{"location": {"state_city":"MA-Lexington",  "zip":"40503"}, "sale_date":"2017-3-5",  "price":275836}'),
    ('{"location": {"state_city":"MA-Belmont",    "zip":"02478"}, "sale_date":"2017-3-17", "price":392567}'),
    ('{"location": {"state_city":"MA-Winchester", "zip":"01890"}, "sale_date":"2017-3-21", "price":389921}');
select * from sales_json;

-- transpose top-level OBJECT only
create or replace table sales_rel(
    id int, location variant, date date, price float) as
select id, v:location, v:sale_date::date, v:price::float
from sales_json;
select * from sales_rel;

-- transpose top-level plus nested OBJECTs (with CAST)
create or replace table sales_rel2(
    id int, state string, zip string, date date, price float) as
select id,
    v:location.state_city::string, v:location.zip::string,
    v:sale_date::date, v:price::float
from sales_json;
select * from sales_rel2;

-- transpose top-level plus nested OBJECTs (no CAST!)
create or replace table sales_rel3(
    id int, state string, zip string, date date, price float) as
select id,
    v:location.state_city, v:location.zip,
    v:sale_date, v:price
from sales_json;
select * from sales_rel3;
