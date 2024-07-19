# see https://stackoverflow.com/questions/64702527/insert-variant-type-from-pandas-into-snowflake
import json, os
import pandas as pd
import snowflake.connector

# connect with the Snowflake Connector for Python
conn = snowflake.connector.connect(
    account='CTB57925',
    user='cristiscu',
    password=os.environ['SNOWSQL_PWD'])

# create test table
sql = """
CREATE OR REPLACE TABLE test.public.pandas(
    DATE date,
    PRODUCT string, 
    PRODUCT_DETAILS variant, 
    ANALYSIS_META variant,
    PRICE float);
"""
conn.cursor().execute(sql)

# create Pandas data frame with one single OBJECT
record = {
    'DATE': '2020-11-05',
    'PRODUCT': 'blue_banana',
    'PRODUCT_DETAILS': json.dumps({'is_blue': True, 'is_kiwi': None}),
    'ANALYSIS_META': json.dumps(None),
    'PRICE': 13.02
}
df = pd.DataFrame(record, index=[0])

# insert data w/ dynamic PARSE_JSON calls
sql = """
INSERT INTO test.public.pandas
SELECT to_date('{DATE}'),
    '{PRODUCT}',
    parse_json('{PRODUCT_DETAILS}'),
    parse_json('{ANALYSIS_META}'),
    {PRICE};
"""
for _, r in df.iterrows():
    conn.cursor().execute(sql.format(**dict(r)))

# display all table data
sql = 'table test.public.pandas'
data = conn.cursor().execute(sql).fetchall()
print(data)
