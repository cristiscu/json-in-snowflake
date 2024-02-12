-- XPath: /
-- JSONPath: $
-- the top JSON object
select v
from json_table;

-- XPath: /store
-- JSONPath: $.store
-- the "store" JSON object
select v:store
from json_table;

-- XPath: /store/bicycle
-- JSONPath: $.store.bicycle
-- the "bicycle" JSON object within "store"
select v:store.bicycle as bicycle, is_array(bicycle)
from json_table;

-- XPath: /store/book
-- JSONPath: $.store.book
-- the "book" JSON array within "store"
select v:store.book as book, is_array(book)
from json_table;