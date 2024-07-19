-- FLATTEN w/ OUTER
-- see https://stackoverflow.com/questions/67330332/flatten-json-data-on-snowflake

select empDetails.value,
    empDetails.value:kind,
    empDetails.value:fullName,
    empDetails.value:age,
    empDetails.value:gender,

    empDetails.value:phoneNumber,
    empDetails.value:phoneNumber.areaCode, 
    empDetails.value:phoneNumber.number,
    
    empDetails.value:children, 
    children.value:name,
    children.value:gender,
    children.value:age,
    
    citiesLived.value:place,
    yearsLived.value:yearsLived
    
from test.public.employee_details emp,
    lateral flatten(v:empDetails) empDetails, 
    lateral flatten(empDetails.value:children, outer=>true) children,
    lateral flatten(empDetails.value:citiesLived, outer=>true) citiesLived,
    lateral flatten(citiesLived.value:yearsLived, outer=>true) yearsLived