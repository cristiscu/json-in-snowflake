using test.public;

-- we have some JSON w/ recursive objects (unknown tree depth!)
create or replace table employees_json (v variant)
as select parse_json($$
{
  "id": 100,
  "name": "Steven King",
  "phone": "(515) 123-4567",
  "hiredate": "2003-06-17",
  "salary": 24000,
  "job": "PRESIDENT",
  "department": "PRESIDENCE",
  "employees": [
    {
      "id": 101,
      "name": "Neena Kochhar",
      "phone": "(515) 123-4568",
      "hiredate": "2003-06-17",
      "salary": 17000,
      "job": "VP",
      "department": "PRESIDENCE",
      "employees": [
        {
          "id": 204,
          "name": "Hermann Baer",
          "phone": "(515) 123-8888",
          "hiredate": "2004-06-07",
          "salary": 10000,
          "job": "SALES REP",
          "department": "SALES"
        },
        {
          "id": 205,
          "name": "Shelley Higgins",
          "phone": "(515) 123-8080",
          "hiredate": "2004-06-07",
          "salary": 12000,
          "job": "CONTROLLER",
          "department": "FINANCE"
        },
        {
          "id": 108,
          "name": "Nancy Greenberg",
          "phone": "(515) 124-4569",
          "hiredate": "2006-01-03",
          "salary": 12000,
          "job": "MANAGER",
          "department": "FINANCE",
          "employees": [
            {
              "id": 111,
              "name": "Ismael Sciarra",
              "phone": "(515) 124-4369",
              "hiredate": "2007-09-30",
              "salary": 7700,
              "job": "ACCOUNTANT",
              "department": "FINANCE"
            },
            {
              "id": 112,
              "name": "Jose Manuel Urman",
              "phone": "(515) 124-4469",
              "hiredate": "2006-03-07",
              "salary": 7800,
              "job": "ACCOUNTANT",
              "department": "FINANCE"
            },
            {
              "id": 113,
              "name": "Luis Popp",
              "phone": "(515) 124-4567",
              "hiredate": "2007-05-21",
              "salary": 6900,
              "job": "ACCOUNTANT",
              "department": "FINANCE"
            }
          ]
        }
      ]
    },
    {
      "id": 102,
      "name": "Lex De Haan",
      "phone": "(515) 123-4569",
      "hiredate": "2003-06-17",
      "salary": 17000,
      "job": "VP",
      "department": "PRESIDENCE",
      "employees": [
        {
          "id": 103,
          "name": "Alexander Hunold",
          "phone": "(590) 423-4567",
          "hiredate": "2006-01-03",
          "salary": 9000,
          "job": "PROGRAMMER",
          "department": "IT",
          "employees": [
            {
              "id": 104,
              "name": "Bruce Ernst",
              "phone": "(590) 423-4568",
              "hiredate": "2007-05-21",
              "salary": 6000,
              "job": "PROGRAMMER",
              "department": "IT"
            },
            {
              "id": 106,
              "name": "Valli Pataballa",
              "phone": "(590) 423-4560",
              "hiredate": "2007-05-21",
              "salary": 4800,
              "job": "PROGRAMMER",
              "department": "IT"
            }
          ]
        }
      ]
    },
    {
      "id": 114,
      "name": "Den Raphaely",
      "phone": "(515) 127-4561",
      "hiredate": "2003-06-17",
      "salary": 11000,
      "job": "MANAGER",
      "department": "ANALYTICS",
      "employees": [
        {
          "id": 115,
          "name": "Alexander Khoo",
          "phone": "(515) 127-4562",
          "hiredate": "2005-12-24",
          "salary": 3100,
          "job": "CLERK",
          "department": "ANALYTICS"
        },
        {
          "id": 116,
          "name": "Shelli Baida",
          "phone": "(515) 127-4563",
          "hiredate": "2005-12-24",
          "salary": 2900,
          "job": "CLERK",
          "department": "ANALYTICS"
        }
      ]
    },
    {
      "id": 121,
      "name": "Adam Fripp",
      "phone": "(650) 123-2234",
      "hiredate": "2003-06-17",
      "salary": 8200,
      "job": "MANAGER",
      "department": "DOCUMENTATION",
      "employees": [
        {
          "id": 129,
          "name": "Laura Bissot",
          "phone": "(650) 124-5234",
          "hiredate": "2004-06-07",
          "salary": 3300,
          "job": "CLERK",
          "department": "DOCUMENTATION"
        }
      ]
    }
  ]
}
$$);
select * from employees_json;

-- get all parent-child relationships, w/ recursive CTE
with recursive cte as (
    select v:name::string as parent, null as child, v as obj
    from employees_json
    union all
    select child.value:name::string, cte.parent, child.value
    from cte, table(flatten(cte.obj:employees)) child)
select * from cte;

-- create relational table from the same result
create or replace table employees_rel(parent string, child string) as
with recursive cte as (
    select v:name::string as parent, null as child, v as obj
    from employees_json
    union all
    select child.value:name::string, cte.parent, child.value
    from cte, table(flatten(cte.obj:employees)) child)
select parent, child from cte;
select * from employees_rel;
