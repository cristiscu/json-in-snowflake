-- Array Elements ([n], [n, m], [:m])
use schema test.public;

-- the author of the second book in the store (as single string value)
-- XPath: /store/book[2]/author
-- JSONPath: $.store.book[1].author
select v:store.book[1].author::string as author
from store_json;

-- first and fourth books in the store
-- XPath: /store/book[position()=1] | /store/book[position()=4]
-- JSONPath: N/A
select v:store.book[0] as book from store_json
union
select v:store.book[3] as book from store_json;

select elem.index, elem.value as book
from store_json, lateral flatten(v:store.book) as elem
qualify row_number() over (order by 1) in (1, 4);

-- first two books in the store
-- XPath: /store/book[position()<=2]
-- JSONPath: $.store.book[:2]
select v:store.book[0] as book from store_json
union
select v:store.book[1] as book from store_json;

select elem.index, elem.value as book
from store_json, lateral flatten(v:store.book) as elem
where elem.index <= 1;
-- qualify row_number() over (order by 1) <= 2;

-- second and third books in the store
-- XPath: /store/book[position()>=2 and position()<=3]
-- JSONPath: $.store.book[1:3]
select v:store.book[1] as book from store_json
union
select v:store.book[2] as book from store_json;

select elem.index, elem.value as book
from store_json, lateral flatten(v:store.book) as elem
where elem.index between 1 and 2;

select elem.index, elem.value as book
from store_json, lateral flatten(array_slice(v:store.book, 1, 3)) as elem
