-- create table desserts w/ embedded toppings
using test.public;

-- w/ embedded toppings ARRAY, as they are
create or replace table desserts1 as
select d.value:id::int id,
    d.value:type::string type,
    d.value:name::string name,
    d.value:ppu::float ppu,
    d.value:topping::array toppings
from desserts_json, table(flatten(v)) d;
table desserts1;

-- w/ TRANSFORMED toppings
create or replace table desserts2 as
select d.value:id::int id,
    d.value:type::string type,
    d.value:name::string name,
    d.value:ppu::float ppu,
    -- d.value:topping::array toppings
    transform(d.value:topping,
		t object -> t:id::int) toppings
from desserts_json, table(flatten(v)) d;
table desserts2;

-- w/ FILTERED + TRANSFORMED toppings
create or replace table desserts3 as
select d.value:id::int id,
    d.value:type::string type,
    d.value:name::string name,
    d.value:ppu::float ppu,
    transform(filter(d.value:topping,
        t object -> t:type::string <> 'Sugar'),
        t object -> t:id::int) toppings
from desserts_json, table(flatten(v)) d;
table desserts3;
