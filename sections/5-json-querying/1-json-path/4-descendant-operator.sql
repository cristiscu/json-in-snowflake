-- Descendant Operator (..)
use schema test.public;

-- all "author" property values from the store, no matter where
-- XPath: /store//author
-- JSONPath: $.store..author
select elem.value::string as author
from store_json, lateral flatten(input => v:store, recursive => true) as elem
where elem.key = 'author';

-- the second "book" object, anywhere in the document
-- XPath: //book[1]
-- JSONPath: $..book[1]
select elem.value[1] as book
from store_json, lateral flatten(input => v, recursive => true) as elem
where elem.key = 'book';