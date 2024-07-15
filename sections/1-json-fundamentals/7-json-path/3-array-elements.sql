-- Array Elements ([n], [n, m], [:m])

-- the author of the second book in the store (as single string value)
-- XPath: /store/book[2]/author
-- JSONPath: $.store.book[1].author

-- first and fourth books in the store
-- XPath: /store/book[position()=1] | /store/book[position()=4]
-- JSONPath: N/A

-- first two books in the store
-- XPath: /store/book[position()<=2]
-- JSONPath: $.store.book[:2]

-- second and third books in the store
-- XPath: /store/book[position()>=2 and position()<=3]
-- JSONPath: $.store.book[1:3]
