-- JSON OBJECT Manipulation Functions

SET json = { 'name': 'Mark', 'children': [ 'Joe', 'Mary' ] };
SET json = parse_json('{"name":"Mark", "children":["Joe", "Mary"]}');
SET json = '{"name":"Mark", "children":["Joe", "Mary"]}';

select PARSE_JSON($json) j, typeof(j);

select OBJECT_KEYS(parse_json($json));

select OBJECT_PICK(parse_json($json), 'children'),
    OBJECT_PICK(parse_json($json), 'name', 'children'),
    OBJECT_PICK(parse_json($json), ['name', 'children']);

select OBJECT_DELETE(parse_json($json), 'children'),
    OBJECT_DELETE(parse_json($json), 'name', 'children');

select OBJECT_INSERT(parse_json($json), 'age', 32),
    OBJECT_INSERT(parse_json($json), 'location', { 'country': 'USA', 'city': 'Seattle' }),
    OBJECT_INSERT(parse_json($json), 'projects', [ 22, 33 ]);
