# see https://docs.snowflake.com/en/developer-guide/snowpark/reference/python/latest/snowpark/api/snowflake.snowpark.functions.parse_json
from snowflake.snowpark import Session
from snowflake.snowpark.functions import parse_json
from snowflake.ml.utils.connection_params import SnowflakeLoginOptions

pars = SnowflakeLoginOptions("test_conn")
session = Session.builder.configs(pars).create()

# show parsed JSON from a DataFrame
data = open("../../../data/store-relaxed.json").read()
df = session.create_dataframe([[data]], schema=["v"])
df.select(parse_json(df["v"])).show()
