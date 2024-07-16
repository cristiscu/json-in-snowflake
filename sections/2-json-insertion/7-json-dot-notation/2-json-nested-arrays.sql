-- JSON w/ Nested Arrays

create or replace table test.public.employee_details(v variant)
as select $$
{
    "empDetails": [
        {
            "kind": "person",
            "fullName": "John Doe",
            "age": 22,
            "gender": "Male",
            "phoneNumber": {
                "areaCode": "206",
                "number": "1234567"
            },
            "children": [
                {
                    "name": "Jane",
                    "gender": "Female",
                    "age": "6"
                },
                {
                    "name": "John",
                    "gender": "Male",
                    "age": "15"
                }
            ],
            "citiesLived": [
                {
                    "place": "Seattle",
                    "yearsLived": [
                        "1995"
                    ]
                },
                {
                    "place": "Stockholm",
                    "yearsLived": [
                        "2005"
                    ]
                }
            ]
        },
        {
            "kind": "person",
            "fullName": "Mike Jones",
            "age": 35,
            "gender": "Male",
            "phoneNumber": {
                "areaCode": "622",
                "number": "1567845"
            },
            "children": [
                {
                    "name": "Earl",
                    "gender": "Male",
                    "age": "10"
                },
                {
                    "name": "Sam",
                    "gender": "Male",
                    "age": "6"
                },
                {
                    "name": "Kit",
                    "gender": "Male",
                    "age": "8"
                }
            ],
            "citiesLived": [
                {
                    "place": "Los Angeles",
                    "yearsLived": [
                        "1989",
                        "1993",
                        "1998",
                        "2002"
                    ]
                },
                {
                    "place": "Washington DC",
                    "yearsLived": [
                        "1990",
                        "1993",
                        "1998",
                        "2008"
                    ]
                },
                {
                    "place": "Portland",
                    "yearsLived": [
                        "1993",
                        "1998",
                        "2003",
                        "2005"
                    ]
                },
                {
                    "place": "Austin",
                    "yearsLived": [
                        "1973",
                        "1998",
                        "2001",
                        "2005"
                    ]
                }
            ]
        },
        {
            "kind": "person",
            "fullName": "Anna Karenina",
            "age": 45,
            "gender": "Female",
            "phoneNumber": {
                "areaCode": "425",
                "number": "1984783"
            },
            "citiesLived": [
                {
                    "place": "Stockholm",
                    "yearsLived": [
                        "1992",
                        "1998",
                        "2000",
                        "2010"
                    ]
                },
                {
                    "place": "Russia",
                    "yearsLived": [
                        "1998",
                        "2001",
                        ""
                    ]
                },
                {
                    "place": "Austin",
                    "yearsLived": [
                        "1995",
                        "1999"
                    ]
                }
            ]
        }
    ]
}
$$;

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
    v:empDetails[0].citiesLived[1].yearsLived[0]

from test.public.employee_details;
