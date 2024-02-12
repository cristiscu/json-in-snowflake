import json, os
import snowflake.connector

conn = snowflake.connector.connect(
    account='FHB91278',
    user='cristiscu',
    password=os.environ['SNOWSQL_PWD'])

query = 'select top 1 products from test.public.store'
row = conn.cursor().execute(query).fetchone()
data = str(row[0])
# print(data)
data = json.loads(data)
print(json.dumps(data, indent=2))
