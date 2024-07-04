using test.public;

create or replace table desserts_json (v variant)
as select parse_json($$
[
	{
		"id": "0001",
		"type": "donut",
		"name": "Cake",
		"ppu": 0.55,
		"batters":
			{
				"batter":
					[
						{ "id": "1001", "type": "Regular" },
						{ "id": "1002", "type": "Chocolate" },
						{ "id": "1003", "type": "Blueberry" },
						{ "id": "1004", "type": "Devil's Food" }
					]
			},
		"topping":
			[
				{ "id": "5001", "type": "None" },
				{ "id": "5002", "type": "Glazed" },
				{ "id": "5005", "type": "Sugar" },
				{ "id": "5007", "type": "Powdered Sugar" },
				{ "id": "5006", "type": "Chocolate with Sprinkles" },
				{ "id": "5003", "type": "Chocolate" },
				{ "id": "5004", "type": "Maple" }
			]
	},
	{
		"id": "0002",
		"type": "donut",
		"name": "Raised",
		"ppu": 0.55,
		"batters":
			{
				"batter":
					[
						{ "id": "1001", "type": "Regular" }
					]
			},
		"topping":
			[
				{ "id": "5001", "type": "None" },
				{ "id": "5002", "type": "Glazed" },
				{ "id": "5005", "type": "Sugar" },
				{ "id": "5003", "type": "Chocolate" },
				{ "id": "5004", "type": "Maple" }
			]
	},
	{
		"id": "0003",
		"type": "donut",
		"name": "Old Fashioned",
		"ppu": 0.55,
		"batters":
			{
				"batter":
					[
						{ "id": "1001", "type": "Regular" },
						{ "id": "1002", "type": "Chocolate" }
					]
			},
		"topping":
			[
				{ "id": "5001", "type": "None" },
				{ "id": "5002", "type": "Glazed" },
				{ "id": "5003", "type": "Chocolate" },
				{ "id": "5004", "type": "Maple" }
			]
	}
]
$$);
table desserts_json;

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
