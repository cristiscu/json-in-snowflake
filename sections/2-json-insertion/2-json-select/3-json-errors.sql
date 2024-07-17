
-- ok JSON --> JSON + NULL + JSON
select parse_json('{ "key": "value" }'),
    check_json('{ "key": "value" }'),
    try_parse_json('{ "key": "value" }');

-- bad JSON --> error + err msg + NULL
select parse_json('{ "key" "value" }');
select check_json('{ "key" "value" }'),
    try_parse_json('{ "key" "value" }');
