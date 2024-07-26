-- full JSON doc to relational tables
use schema test.public;

-- create table desserts
create or replace table desserts as
select d.value:id::int id,
    d.value:type::string type,
    d.value:name::string name,
    d.value:ppu::float ppu
from desserts_json, table(flatten(v)) d
order by id;
table desserts;

-- create table batters
create or replace table batters as
select distinct b.value:id::int id, b.value:type::string type
from desserts_json,
    table(flatten(v)) d,
    table(flatten(d.value:batters.batter)) b
order by id;
table batters;

-- create table toppings
create or replace table toppings as
select distinct t.value:id::int id, t.value:type::string type
from desserts_json,
    table(flatten(v)) d,
    table(flatten(d.value:topping)) t
order by id;
table toppings;

-- create many-to-many table desserts_batters
create or replace table desserts_batters as
select
    d.value:id::int id_dessert,
    b.value:id::int id_batter
from desserts_json,
    table(flatten(v)) d,
    table(flatten(d.value:batters.batter)) b;
table desserts_batters;

-- create many-to-many table desserts_toppings
create or replace table desserts_toppings as
select
    d.value:id::int id_dessert,
    t.value:id::int id_topping
from desserts_json,
    table(flatten(v)) d,
    table(flatten(d.value:topping)) t;
table desserts_toppings;
