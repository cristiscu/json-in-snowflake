import json
from snowflake.snowpark import Session
from snowflake.ml.utils.connection_params import SnowflakeLoginOptions

#pars = {
#    "account": 'CTB57925',
#    "user": 'cristiscu',
#    "password": os.environ['SNOWSQL_PWD']}
pars = SnowflakeLoginOptions("test_conn")
session = Session.builder.configs(pars).create()

query = 'table test.public.store'
rows = session.sql(query).collect()
data = str(rows[0][0])

# print(data)
data = json.loads(data)
print(json.dumps(data, indent=2))
