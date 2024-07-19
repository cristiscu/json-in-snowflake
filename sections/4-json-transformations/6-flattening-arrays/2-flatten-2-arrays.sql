-- inspired from Data Engineer exam question
use test.public;

create or replace table cities (v variant);
insert into cities
select to_variant('{ cities: [
    { city: "Vancouver",
      persons: [{ person: "Mark", age: 55}, {person: "John", age: 80 }] },
    { city: "Toronto",
      persons: [{person: "Mary", age: 20}, {person: "George", age: 44}] },
    { city: "Montreal",
      persons: [{ person: "Jane", age: 30}] }
  ]}');

/*
Expected result:

CITY	       PERSON	 AGE
Vancouver    Mark	   55
Vancouver	   John	   80
Toronto	     Mary	   20
Toronto	     George	 44
Montreal	   Jane	   30
*/

-- no results
with x as (
    select parse_json(v) as json from cities)
select value:city::string as city,
    value:person::string as person,
    value:age as age
from x, lateral flatten(input => x.json:cities:persons);

-- bad results
with x as (
    select parse_json(v) as json from cities)
select value:city::string as city,
    value:persons:person::string as person,
    value:person:age as age
from x, table(flatten(input => x.json:cities));

-- good one
with x as (
    select parse_json(v) as json from cities),
y as (
    select value:city::string as city,
        value:persons as persons
    from x, lateral flatten(input => x.json:cities))
select y.city,
    value:person::string as person,
    value:age as age
from y, lateral flatten(input => parse_json(y.persons));

-- equivalent
select c.value:city::string as city,
    p.value:person::string as person,
    p.value:age as age
from cities,
    lateral flatten(parse_json(v):cities) c,
    lateral flatten(c.value:persons) p;
