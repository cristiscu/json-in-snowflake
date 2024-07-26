-- view over JSON staged file
use schema test.public;

-- CREATE OR REPLACE TABLE store(v VARIANT);
-- COPY INTO store FROM @stage1;
-- TABLE store;

select $1:store.book
from @stage1/store.json.gz;

select book.value:title title,
    book.value:author author,
    book.value:category category,
    book.value:price price,
    book.value:isbn isbn
from @stage1/store.json.gz,
    lateral flatten($1:store.book) book;

create or replace view books
as select book.value:title title,
    book.value:author author,
    book.value:category category,
    book.value:price price,
    book.value:isbn isbn
from @stage1/store.json.gz,
    lateral flatten($1:store.book) book;
table books;
