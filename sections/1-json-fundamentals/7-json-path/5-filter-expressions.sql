-- Filter Expressions ([?(…)])

-- only the books with a "price" below $10
-- XPath: /store/book[price<10]
-- JSONPath: $.store.book[?(@.price<10)]

-- only the books with an "isbn" property defined
-- XPath: /store/book[isbn]
-- JSONPath: $.store.book[?(@.isbn)]
