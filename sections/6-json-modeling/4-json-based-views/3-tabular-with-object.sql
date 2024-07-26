-- view w/ JSON ARRAY over 1-N relationship and JSON OBJECT over 1-1 relationship
use schema test.public;

-- some persons may have an address
create or replace table addresses (id_person int, country string, city string)
as select * from values
(1, 'USA', 'Seattle'), (2, 'Canada', 'Vancouver'), (3, 'France', 'Paris');

-- all persons w/ (optional) ARRAY children and OBJECT address
select p.name, cv.children,
    OBJECT_CONSTRUCT('country', a.country, 'city', a.city) address
from persons p
    left join children_view cv on p.name = cv.parent
    left join addresses a on p.id = a.id_person;

-- create view over this
create or replace view addresses_view
as select p.name, cv.children,
    OBJECT_CONSTRUCT('country', a.country, 'city', a.city) address
from persons p
    left join children_view cv on p.name = cv.parent
    left join addresses a on p.id = a.id_person;
table addresses_view;
