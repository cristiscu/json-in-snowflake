-- get last element of an array with unknown size
-- see https://stackoverflow.com/questions/60495882/get-last-element-of-array-of-unknown-size

-- not like in Python
with cte as (select array_construct(1, 2, 3, 4, 5, 6, 7) as a)
select a, a[-1] as last
from cte;

with cte as (select array_construct(1, 2, 3, 4, 5, 6, 7) as a)
select a, a[array_size(a)-1] as last
from cte;

select array_construct(1, 2, 3, 4, 5, 6, 7) as a,
    a[array_size(a)-1] as last;

select [1, 2, 3, 4, 5, 6, 7]::array(int) as a,
    a[array_size(a)-1] as last;

select array_slice([1, 2, 3, 4, 5, 6, 7], -1, 9999)[0] as last;

CREATE OR REPLACE FUNCTION array_element(a array, offset double)
    RETURNS STRING
    LANGUAGE JAVASCRIPT
AS 'return OFFSET < 0 ? A[A.length + OFFSET] : A[OFFSET]';
select array_element([1, 2, 3, 4, 5, 6, 7], -1) as last;
