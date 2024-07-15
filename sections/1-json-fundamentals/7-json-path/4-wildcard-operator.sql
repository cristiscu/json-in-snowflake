-- Wildcard Operator (*, [*])

-- all child JSON objects in store (as individual records)
-- XPath: /store/*
-- JSONPath: $.store.*

-- first "book" object anywhere in the document
-- XPath: /*/book[1]
-- JSONPath: $.*.book[1]

-- all JSON book objects in the store (as individual records)
-- XPath: /store/book[*]
-- JSONPath: $.store.book[*]

-- all author string values of all JSON book objects in the store
-- XPath: /store/book[*]/author
-- JSONPath: $.store.book[*].author
