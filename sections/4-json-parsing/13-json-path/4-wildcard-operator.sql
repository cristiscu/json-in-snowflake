-- Wildcard Operator (*, [*])
use schema test.public;

-- all child JSON objects in store (as individual records)
-- XPath: /store/*
-- JSONPath: $.store.*
select elem.key, elem.value
from store_json, lateral flatten(v:store) as elem;

-- first "book" object anywhere in the document
-- XPath: /*/book[1]
-- JSONPath: $.*.book[1]
select elem.value
from store_json, lateral flatten(v, recursive => true) elem
where elem.key = 'book';

-- all JSON book objects in the store (as individual records)
-- XPath: /store/book[*]
-- JSONPath: $.store.book[*]
select elem.index, elem.value as book, is_object(book)
from store_json, lateral flatten(v:store.book) as elem;

-- all author string values of all JSON book objects in the store
-- XPath: /store/book[*]/author
-- JSONPath: $.store.book[*].author
select elem.value:author::string as author
from store_json, lateral flatten(v:store.book) as elem;
