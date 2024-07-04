-- Filter Expressions ([?(…)])
use schema test.public;

-- only the books with a "price" below $10
-- XPath: /store/book[price<10]
-- JSONPath: $.store.book[?(@.price<10)]
select elem.value as book
from store_json, lateral flatten(v:store.book) as elem
where elem.value:price < 10;

-- only the books with an "isbn" property defined
-- XPath: /store/book[isbn]
-- JSONPath: $.store.book[?(@.isbn)]
select elem.value as book
from store_json, lateral flatten(v:store.book) as elem
where elem.value:isbn is not null;