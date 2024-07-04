-- convert one full table to JSON
-- see https://stackoverflow.com/questions/71864782/snowflake-convert-an-entire-table-to-json
use schema test.public;

create or replace table inventory(product varchar, price float, quantity int);
insert into inventory values ('apples', 22.50, 200), ('nuts', 11.22, 120), ('avocado', 12.50, 150);
table inventory;

/*
  apples        { "price": 22.5,  "quantity": 200 },
  avocado       { "price": 12.5,  "quantity": 150 },
  nuts          { "price": 11.22, "quantity": 120 }
*/
SELECT product, object_construct('price', price, 'quantity', quantity) as obj
FROM inventory;

/*
{
  "apples":  { "price": 22.5,  "quantity": 200 },
  "avocado": { "price": 12.5,  "quantity": 150 },
  "nuts":    { "price": 11.22, "quantity": 120 }
}
*/
SELECT object_agg(product, object_construct('price', price, 'quantity', quantity)) as obj
FROM inventory;
