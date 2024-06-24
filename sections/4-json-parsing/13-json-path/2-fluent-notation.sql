-- Fluent Notation ($.elem1.elem2)
use schema test.public;

-- XPath: /
-- JSONPath: $
-- the top JSON object
select v
from store2;

-- XPath: /store
-- JSONPath: $.store
-- the "store" JSON object
select v:store
from store2;

-- XPath: /store/bicycle
-- JSONPath: $.store.bicycle
-- the "bicycle" JSON object within "store"
select v:store.bicycle as bicycle, is_array(bicycle)
from store2;

-- XPath: /store/book
-- JSONPath: $.store.book
-- the "book" JSON array within "store"
select v:store.book as book, is_array(book)
from store2;