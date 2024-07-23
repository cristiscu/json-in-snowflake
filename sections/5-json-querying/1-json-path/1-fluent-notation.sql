-- Fluent Notation ($.elem1.elem2)
use schema test.public;

-- the top JSON object (~everything)
-- XPath: *
-- JSONPath: $
select v
from store_json;

-- the top "store" JSON object
-- XPath: /store
-- JSONPath: $.store
select v:store
from store_json;

-- the "bicycle" JSON object within the top "store"
-- XPath: /store/bicycle
-- JSONPath: $.store.bicycle
select v:store.bicycle as bicycle, is_array(bicycle)
from store_json;

-- the "book" JSON array within the top "store"
-- XPath: /store/book
-- JSONPath: $.store.book
select v:store.book as book, is_array(book)
from store_json;
