-- Upload an NDJON file in an internal stage
-- SNOWSQL -c test_conn -f 10-infer-schema-setup.sql

CREATE OR REPLACE FILE FORMAT test.public.json_format
    TYPE=JSON;

CREATE OR REPLACE STAGE test.public.stage
    FILE_FORMAT=test.public.json_format;

PUT file://../../../data/home_sales.json @test.public.stage;

/*
{"location": {"state_city": "MA-Lexington","zip": "40503"},"sale_date": "2017-3-5","price": "275836"}
{"location": {"state_city": "MA-Belmont","zip": "02478"},"sale_date": "2017-3-17","price": "392567"}
{"location": {"state_city": "MA-Winchester","zip": "01890"},"sale_date": "2017-3-21","price": "389921"}
*/
