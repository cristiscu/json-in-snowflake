# see https://stackoverflow.com/questions/77729356/is-there-a-way-to-select-a-specific-column-in-a-snowpark-df-if-its-in-json-form
import json
from snowflake.snowpark import Session
from snowflake.ml.utils.connection_params import SnowflakeLoginOptions

pars = SnowflakeLoginOptions("test_conn")
session = Session.builder.configs(pars).create()

# load table content + get first JSON cell from DataFrame
df = session.table("test.public.store")
jsn = json.loads(df.select(df["v"]).collect()[0][0])

# get title of the third book (from JSON doc)
title = jsn["store"]["book"][2]["title"]
print(f"Third book's title: {title}")
