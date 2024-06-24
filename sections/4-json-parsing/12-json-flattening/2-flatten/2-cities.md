## Question

**You have the following table, with some JSON data:**

```
create table cities (v variant);
insert into cities
  select to_variant('{ cities: [
      { city: "Vancouver",
        persons: [{ person: "Kima", age: 110}, {person: "Milan", age: 200 }] },
      { city: "Toronto",
        persons: [{person: "Nadji", age: 20}, {person: "Het", age: 44}] },
      { city: "Montreal",
        persons: [{ person: "Nasko", age: 30}] }
    ]}');
```

**Which SQL statement will display data in tabular format, as below?**

```
CITY	       PERSON	 AGE
Vancouver    Kima	   110
Vancouver	   Milan	 200
Toronto	     Nadji	 20
Toronto	     Het	   44
Montreal	   Nasko	 30
```

A)
```
with x as (
  select parse_json(v) as json from cities)
select value:city::string as city,
    value:person::string as person,
    value:age as age
  from x, lateral flatten(input => x.json:cities:persons);
```
B)
```
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
```
C)
```
with x as (
  select parse_json(v) as json from cities)
select value:city::string as city,
    value:persons:person::string as person,
    value:person:age as age
  from x, table(flatten(input => x.json:cities));
```
