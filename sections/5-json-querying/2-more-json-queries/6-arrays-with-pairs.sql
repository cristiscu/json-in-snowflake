-- Arrays with pairs of values
-- see https://stackoverflow.com/questions/59100439/lateral-flatten-two-columns-with-different-array-length-in-snowflake

use schema test.public;

create or replace table customers(id int, name string, nr variant, cities variant)
    as select $1, $2, parse_json($3), parse_json($4) from values
    (101, 'Richards', '["34242423", "2342343"]', '["Toronto", "Stoney Creek"]'),
    (102, 'Paulson', '["5987686", "87887687"]', '["Hamilton", "Burlington"]'),
    (103, 'Johnson', '["65565", "231231"]', '["Kuala Lumpur", "New York"]'),
    (104, 'Ali', '["8978", "565645", "223123"]', '["Kuala Lumpur", "London"]');

/*
Desired Output:

ID	NAME	    NR	        CITY
----------------------------------------
101	Richards	34242423	Toronto
101	Richards	2342343	    Stoney Creek
102	Paulson	    5987686	    Hamilton
102	Paulson	    87887687	Burlington
103	Johnson	    65565	    Kuala Lumpur
103	Johnson	    231231	    New York
104	Ali	        8978	    Kuala Lumpur
104	Ali	        565645	    London
104	Ali	        223123	    null
*/

-- (1) w/ index on second array
select id, name, f.value nr, cities[f.index] city
    from customers,
    lateral flatten(nr) f
    order by id;

-- (2) w/ SPLIT
select id, name, trim(f.value, '[]" ') nr, trim(SPLIT(cities, ',')[f.index], '[]" ') city
    from customers,
    lateral flatten(SPLIT(nr, ',')) f;
