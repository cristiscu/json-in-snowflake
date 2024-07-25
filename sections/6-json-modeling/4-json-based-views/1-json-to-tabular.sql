-- view w/ top JSON props
-- see https://stackoverflow.com/questions/69754397/how-can-i-extract-a-json-column-into-new-columns-automatically-in-snowflake-sql
use schema test.public;

/*
Initial Output:
id  name  value
1   TV1   {"URL": "www.url1.com", "Icon": "some_icon1"}
2   TV2   {"URL": "www.url2.com", "Icon": "some_icon2", "Facebook": "Facebook_URL"}
3   TV3   {"URL": "www.url3.com", "Icon": "some_icon3", "Twitter": "Twitter_URL"}

Expected Output:
id  name  url           icon            facebook      twitter
1   TV1   www.url1.com  some_icon1      
2   TV2   www.url2.com  some_icon2      Facebook_URL  
3   TV3   www.url3.com  some_icon3                    Twitter_URL
*/
create or replace table social_media(id int, name string, value variant) as
select $1, $2, parse_json($3)
from values
    (1, 'TV1', '{"URL": "www.url1.com", "Icon": "some_icon1"}'),
    (2, 'TV2', '{"URL": "www.url2.com", "Icon": "some_icon2", "Facebook": "Facebook_URL"}'),
    (3, 'TV3', '{"URL": "www.url3.com", "Icon": "some_icon3", "Twitter": "Twitter_URL"}');
table social_media;

SELECT id, name,
    value:URL::varchar as url,
    value:Icon::varchar as icon,
    value:Facebook::varchar as facebook,
    value:Twitter::varchar as twitter
FROM social_media;

create or replace view social_media_view
as SELECT id, name,
    value:URL::varchar as url,
    value:Icon::varchar as icon,
    value:Facebook::varchar as facebook,
    value:Twitter::varchar as twitter
FROM social_media;
table social_media_view;
