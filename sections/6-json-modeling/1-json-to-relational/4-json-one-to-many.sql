-- JSON w/ nested ARRAY
use schema test.public;

-- select first book
select v:store.book[0]
from store_json;

-- select all books
select b.value, b.index
from store_json, table(flatten(v:store.book)) b;

-- create books table
create or replace table books_rel(
    id int, title string, author string, category string, price float) as
select b.index, b.value:title, b.value:author, b.value:category, b.value:price
from store_json, lateral flatten(v:store.book) b;
select * from books_rel;
