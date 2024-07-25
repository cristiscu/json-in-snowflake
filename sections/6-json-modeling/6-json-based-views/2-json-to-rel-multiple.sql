-- view w/ JSON ARRAY over 1-N relationship
use schema test.public;

create or replace table persons (id int, name string)
as select * from values
(1, 'John'), (2, 'Jack'), (3, 'Anne'), (4, 'Mary'), (5, 'Jane');

create or replace table children (id_parent int, id_child int)
as select * from values
(1, 2), (1, 3), (3, 4);

-- tabular parent-child pairs
select p.name as parent, c.name as child
from persons p
    left join children pc on p.id = pc.id_parent
    inner join persons c on c.id = pc.id_child;

-- LISTAGG
select p.name as parent,
    LISTAGG(c.name, ', ') as children
from persons p
    left join children pc on p.id = pc.id_parent
    inner join persons c on c.id = pc.id_child
group by parent;

-- ARRAY_AGG
select p.name as parent,
    ARRAY_AGG(c.name) as children
from persons p
    left join children pc on p.id = pc.id_parent
    inner join persons c on c.id = pc.id_child
group by parent;

-- view w/ JSON ARRAY for the children
create or replace view children_view
as select distinct p.name as parent,
    ARRAY_AGG(c.name) over (partition by parent) as children
from persons p
    left join children pc on p.id = pc.id_parent
    inner join persons c on c.id = pc.id_child;
table children_view;
