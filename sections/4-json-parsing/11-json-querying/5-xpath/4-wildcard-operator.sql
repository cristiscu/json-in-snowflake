-- XPath: /store/*
-- JSONPath: $.store.*
-- all child JSON objects in store (as individual records)
select elem.value as child
from json_table, lateral flatten(v:store) as elem;

-- XPath: /*/book[1]
-- JSONPath: $.*.book[1]
select elem.value
from json_table, lateral flatten(v) elem;

-- XPath: /store/book[*]
-- JSONPath: $.store.book[*]
-- all JSON book objects in the store (as individual records)
select elem.value as book, is_object(book)
from json_table, lateral flatten(v:store.book) as elem;

-- XPath: /store/book[*]/author
-- JSONPath: $.store.book[*].author
-- all author string values of all JSON book objects in the store
select elem.value:author::string as author
from json_table, lateral flatten(v:store.book) as elem;