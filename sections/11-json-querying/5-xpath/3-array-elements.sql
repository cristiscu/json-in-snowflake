-- XPath: /store/book[1]/author
-- JSONPath: $.store.book[1].author
-- the author of the second book in the store (as single string value)
select v:store.book[1].author::string as author
from json_table;

-- XPath: /store/book[position()=0] | /store/book[position()=3]
-- JSONPath: $.store.book[0, 3]
-- first and fourth books in the store
select elem.value as book
from json_table, lateral flatten(v:store.book) as elem
qualify row_number() over (order by 1) in (1, 4);

-- XPath: /store/book[position() <= 2]
-- JSONPath: $.store.book[:2]
-- first two books in the store
select elem.value as book
from json_table, lateral flatten(v:store.book) as elem
qualify row_number() over (order by 1) <= 2;

-- XPath: /store/book[...]
-- JSONPath: $.store.book[1:3]
-- second and third books in the store
select elem.value as book
from json_table, lateral flatten(array_slice(v:store.book, 1, 3)) as elem