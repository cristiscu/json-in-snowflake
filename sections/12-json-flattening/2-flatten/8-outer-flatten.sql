-- FLATTEN w/ OUTER
-- see https://stackoverflow.com/questions/67330332/flatten-json-data-on-snowflake

select empd.value:kind,
    empd.value:fullName,
    empd.value:age,
    empd.value:gender,   
    empd.value:phoneNumber,
    empd.value:phoneNumber.areaCode, 
    empd.value:phoneNumber.number,
    empd.value:children, 
    chldrn.value:name,
    chldrn.value:gender,
    chldrn.value:age,
    city.value:place,
    yr.value:yearsLived
from test.public.employee_details emp,
    lateral flatten(input=>emp.v:empDetails) empd , 
    lateral flatten(input=>empd.value:children, OUTER => TRUE) chldrn,
    lateral flatten(input=>empd.value:citiesLived) city,
    lateral flatten(input=>city.value:yearsLived) yr