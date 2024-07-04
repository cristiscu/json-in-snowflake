using test.public;

-- we have some JSON w/ recursive objects (unknown tree depth!)
create or replace table store_json (v variant)
as select parse_json($$
{
    "store": {
        "book": [ 
            {
                "category": "reference",
                "author": "Nigel Rees",
                "title": "Sayings of the Century",
                "price": 8.95
            },
            {
                "category": "fiction",
                "author": "Evelyn Waugh",
                "title": "Sword of Honour",
                "price": 12.99
            },
            {
                "category": "fiction",
                "author": "Herman Melville",
                "title": "Moby Dick",
                "isbn": "0-553-21311-3",
                "price": 8.99
            },
            {
                "category": "fiction",
                "author": "J. R. R. Tolkien",
                "title": "The Lord of the Rings",
                "isbn": "0-395-19395-8",
                "price": 22.99
            }
        ],
        "bicycle": {
            "color": "red",
            "price": 19.95
        }
    }
}
$$);
select * from store_json;

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
