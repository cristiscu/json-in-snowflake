-- JSON Extraction Functions
-- see https://docs.snowflake.com/en/sql-reference/functions-semistructured

set json = $$
{
    "custom":
    [
        { "name": "addressIdNum",    "valueNum": 12345678},
        { "name": "cancelledDateAt", "valueAt": "2013-04-05 01:02:03" }
    ]
}
$$;
select
    v:custom[0].name::string,
    v:custom[0].valueNum::integer,
    v:custom[1].valueAt::timestamp
from (select parse_json($json) v);

-- GET
select
    v:custom[0].name::string,

    get(v:custom, 0),
    get(get(v:custom, 0), 'name'),
    get(v:custom[0], 'name')
    
from (select parse_json($json) v);

-- GET_IGNORE_CASE
select
    v:custom[0].name::string,

    get(v:custom[0], 'NAME'),
    get_ignore_case(v:custom[0], 'NAME')
    
from (select parse_json($json) v);

-- GET_PATH
select
    v:custom[0].name::string,
    get_path(v:custom, '[0]'),
    get_path(v:custom, '[0].name'),
    get_path(v, 'custom[0].name')
from (select parse_json($json) v);

select
    v:custom[0].name::string,
    get(get(get(v, 'custom'), 0), 'name'),
    get_path(get_path(get_path(v, 'custom'), '[0]'), 'name')
from (select parse_json($json) v);

-- JSON_EXTRACT_PATH_TEXT
select
    json_extract_path_text($json, 'custom[0].name'),
    to_varchar(get_path(parse_json($json), 'custom[0].name'));
