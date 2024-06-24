-- Descendant Operator (..)
use schema test.public;

-- XPath: /store//author
-- JSONPath: $.store..author
-- all "author" property values from the store, no matter where
select elem.value::string as author
from store2, lateral flatten(input => v:store, recursive => true) as elem
where elem.key = 'author';

-- XPath: //book[1]
-- JSONPath: $..book[1]
-- the second "book" object, anywhere in the document
select elem.value[1] as book
from store2, lateral flatten(input => v, recursive => true) as elem
where elem.key = 'book';