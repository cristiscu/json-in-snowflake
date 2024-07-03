-- Array Elements ([n], [n, m], [:m])
use schema test.public;

-- the author of the second book in the store (as single string value)
-- XPath: /store/book[2]/author
-- JSONPath: $.store.book[1].author
select v:store.book[1].author::string as author
from store2;

-- first and fourth books in the store
-- XPath: /store/book[position()=1] | /store/book[position()=4]
-- JSONPath: N/A
select elem.value as book
from store2, lateral flatten(v:store.book) as elem
qualify row_number() over (order by 1) in (1, 4);

-- first two books in the store
-- XPath: /store/book[position()<=2]
-- JSONPath: $.store.book[:2]
select elem.value as book
from store2, lateral flatten(v:store.book) as elem
qualify row_number() over (order by 1) <= 2;

-- second and third books in the store
-- XPath: /store/book[position()>=2 and position()<=3]
-- JSONPath: $.store.book[1:3]
select elem.value as book
from store2, lateral flatten(array_slice(v:store.book, 1, 3)) as elem
