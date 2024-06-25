import json, os
import snowflake.connector

conn = snowflake.connector.connect(
    account='CTB57925',
    user='cristiscu',
    password=os.environ['SNOWSQL_PWD'])

query = 'table test.public.store'
row = conn.cursor().execute(query).fetchone()
data = str(row[0])

# print(data)
data = json.loads(data)
print(json.dumps(data, indent=2))
