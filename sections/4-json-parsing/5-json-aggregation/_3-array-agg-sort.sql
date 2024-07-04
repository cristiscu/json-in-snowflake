-- count referenced documents
-- see https://stackoverflow.com/questions/66643770/how-can-you-sort-string-value-or-array-in-sql
use schema test.public;

create or replace table docs(doc varchar, users array) as
select $1, strtok_to_array($2, ',') from values
    ('doc1', 'Ann,Bob'),
    ('doc2', 'Bob,Ann'),
    ('doc2', 'Chris,Bob,Ann');
table docs;

-- tricky, not working :(
SELECT usrs, count(doc) as count
FROM (
  SELECT doc, array_agg(user) WITHIN GROUP (ORDER BY user) as usrs
  FROM (
    SELECT doc, u.value as user
    FROM docs d, lateral flatten(users) u)
  GROUP BY 1)
GROUP BY 1
ORDER BY 1;
