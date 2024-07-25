-- nested complex OBJECT with all JSON NULLs removed and no empty ARRAY/OBJECT
-- see https://stackoverflow.com/questions/72458163/how-to-check-empty-json-in-snowflake
use schema test.public;

-- OBJECT with JSON NULLs and empty OBJECT/ARRAY
select p.name as person,
    OBJECT_CONSTRUCT_KEEP_NULL(
        'children', cv.children,
        'address', OBJECT_CONSTRUCT('country', a.country, 'city', a.city)) info
from persons p
    left join children_view cv on p.name = cv.parent
    left join addresses a on p.id = a.id_person;

-- make JSON NULLs
select p.name name, cv.children children,
    iff(children is null, null, children) children2,
    OBJECT_CONSTRUCT('country', a.country, 'city', a.city) address,
    iff(address=OBJECT_CONSTRUCT(), NULL, address) address2
from persons p
    left join children_view cv on p.name = cv.parent
    left join addresses a on p.id = a.id_person;

-- JSON OBJECT w/ all NULL and empty OBJECT/ARRAY removed
with cte as (
    select p.name name, cv.children children,
        iff(children is null, null, children) children2,
        OBJECT_CONSTRUCT('country', a.country, 'city', a.city) address,
        iff(address=OBJECT_CONSTRUCT(), NULL, address) address2
    from persons p
        left join children_view cv on p.name = cv.parent
        left join addresses a on p.id = a.id_person),
cte2 as (
    select name, 'children' key, children2::variant value from cte
    union
    select name, 'address', address2::variant from cte)
select name, OBJECT_AGG(key, value) info
from cte2
group by name
having info<>OBJECT_CONSTRUCT();

-- create view over this
create or replace view addresses_view_clean
as with cte as (
        select p.name name, cv.children children,
            iff(children is null, null, children) children2,
            OBJECT_CONSTRUCT('country', a.country, 'city', a.city) address,
            iff(address=OBJECT_CONSTRUCT(), NULL, address) address2
        from persons p
            left join children_view cv on p.name = cv.parent
            left join addresses a on p.id = a.id_person),
    cte2 as (
        select name, 'children' key, children2::variant value from cte
        union
        select name, 'address', address2::variant from cte)
    select name, OBJECT_AGG(key, value) info
    from cte2
    group by name
    having info<>OBJECT_CONSTRUCT();
table addresses_view_clean;
