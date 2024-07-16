
-- STRTOK_TO_ARRAY
select strtok_to_array('1,2,3'),
    strtok_to_array('1 2 3'),
    strtok_to_array('1,2,3', ','),
    strtok_to_array('1,2,3', ',')::array(int),
    strtok_to_array('1, 2.3', ',.');

-- ARRAY_TO_STRING
select array_to_string([1, 2, 3], ', ');
