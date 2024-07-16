-- JSON w/ Nested Arrays

select v:empDetails,
    v:empDetails[0],

    v:empDetails[0].fullName,
    v:empDetails[0]['fullName'],
    v:empDetails[0].age,
    v:empDetails[0].gender,

    v:empDetails[0].phoneNumber,
    v:empDetails[0].phoneNumber.areaCode, 
    v:empDetails[0].phoneNumber.number,
    
    v:empDetails[0].children, 
    v:empDetails[0].children[0].name,
    v:empDetails[0].children[0].gender,
    v:empDetails[0].children[0].age,
    
    v:empDetails[0].citiesLived[1].place,
    v:empDetails[0].citiesLived[1].yearsLived,
    v:empDetails[0].citiesLived[1].yearsLived[0],

from test.public.employee_details;
