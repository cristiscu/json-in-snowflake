-- JSON OBJECT Manipulation Functions

SET json = '[{"name":"Mark", "children":["Joe", "Mary"]}, {"name":"Jane"}]';

select PARSE_JSON($json)[0];

select OBJECT_KEYS(parse_json($json)[0]);

select OBJECT_PICK(parse_json($json)[0], 'children'),
    OBJECT_PICK(parse_json($json)[0], 'name', 'children'),
    OBJECT_PICK(parse_json($json)[0], ['name', 'children']);

select OBJECT_DELETE(parse_json($json)[0], 'children'),
    OBJECT_DELETE(parse_json($json)[0], 'name', 'children');

select OBJECT_INSERT(parse_json($json)[0], 'age', 32),
    OBJECT_INSERT(parse_json($json)[0], 'location', OBJECT_CONSTRUCT('country', 'USA', 'city', 'Seattle')),
    OBJECT_INSERT(parse_json($json)[0], 'projects', ARRAY_CONSTRUCT(22, 33));
