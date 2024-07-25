-- create external stage in public S3 bucket (temp --> hide at the end!)
-- SNOWSQL -c test_conn -f 1-setup-script.sql
USE SCHEMA test.public;

CREATE OR REPLACE FILE FORMAT format1 TYPE=JSON;

/*
Use bucket policy for public S3 bucket (replace 'mypublicbucket321' with your bucket name):
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

-- create public/ folder in the S3 bucket, w/ test/ and employees/ subfolders
CREATE OR REPLACE STAGE stage_ext URL='s3://mypublicbucket321/public/';

-- manually upload in the AWS console the files below in each related folder
-- PUT file://../../../data/test11.json @stage_ext/test/;
-- PUT file://../../../data/test12.json @stage_ext/test/;
-- PUT file://../../../data/test13.json @stage_ext/test/;
-- PUT file://../../../data/test14.json @stage_ext/test/;
-- PUT file://../../../data/employees-array.json @stage_ext/employees/;

LIST @stage_ext;
