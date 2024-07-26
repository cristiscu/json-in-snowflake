-- JSON w/ two-level nested/chained ARRAYs
use schema test.public;

select d.value:id::int id,
    d.value:type::string type,
    d.value:name::string name,
    d.value:ppu::float ppu
from desserts_json,
    table(flatten(v)) d
order by id;

select distinct
    b.value:id::int id,
    b.value:type::string type
from desserts_json,
    table(flatten(v)) d,
    table(flatten(d.value:batters.batter)) b
order by id;
