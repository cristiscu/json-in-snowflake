import json, os
from snowflake.snowpark import Session

pars = {
    "account": 'FHB91278',
    "user": 'cristiscu',
    "password": os.environ['SNOWSQL_PWD']}
session = Session.builder.configs(pars).create()

query = 'select top 1 products from test.public.store'
rows = session.sql(query).collect()
data = str(rows[0][0])
# print(data)
data = json.loads(data)
print(json.dumps(data, indent=2))
