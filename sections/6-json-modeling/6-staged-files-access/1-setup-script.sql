-- create internal stage and upload JSON file
-- SNOWSQL -c test_conn -f 1-setup-script.sql
USE SCHEMA test.public;

-- (1) create internal stage
CREATE OR REPLACE STAGE stage1 FILE_FORMAT=(TYPE=JSON);

PUT file://../../../data/store.json @stage1;

LIST @stage1;

-- =======================================================
-- (2) create external stage (replace 'mypublicbucket321' with your bucket name)
-- make public/ folder inside and upload the files below, found in the data/ folder
/*
Use bucket policy for public bucket:
{
    "Version": "2008-10-17",
    "Statement": [{
            "Sid": "AllowPublicRead",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::mypublicbucket321",
                "arn:aws:s3:::mypublicbucket321/*"
            ]}]
}
*/
CREATE OR REPLACE FILE FORMAT format1 TYPE=JSON;
CREATE OR REPLACE STAGE stage_ext URL='s3://mypublicbucket321/public/';

-- PUT file://../../../data/test11.json @stage_ext/test/;
-- PUT file://../../../data/test12.json @stage_ext/test/;
-- PUT file://../../../data/test13.json @stage_ext/test/;
-- PUT file://../../../data/test14.json @stage_ext/test/;

-- PUT file://../../../data/employees-array.json @stage_ext/employees/;

LIST @stage_ext;
