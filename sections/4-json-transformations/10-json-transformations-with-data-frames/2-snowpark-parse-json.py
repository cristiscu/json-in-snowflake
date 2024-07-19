# see https://docs.snowflake.com/en/developer-guide/snowpark/reference/python/latest/snowpark/api/snowflake.snowpark.functions.parse_json
from snowflake.snowpark import Session
from snowflake.snowpark.functions import parse_json
from snowflake.ml.utils.connection_params import SnowflakeLoginOptions

jsn = """
{
    store: {
        book: [ 
            {
                category: 'reference',
                author: 'Nigel Rees',
                title: 'Sayings of the Century',
                price: 8.95
            },
            {
                "category": "fiction",
                "author": "Evelyn Waugh",
                "title": "Sword of Honour",
                "price": 12.99
            },
            {
                "category": "fiction",
                "author": "Herman Melville",
                "title": "Moby Dick",
                "isbn": "0-553-21311-3",
                "price": 8.99
            },
            {
                "category": "fiction",
                "author": "J. R. R. Tolkien",
                "title": "The Lord of the Rings",
                "isbn": "0-395-19395-8",
                "price": 22.99
            }
        ],
        "bicycle": {
            "color": "red",
            "price": 19.95
        }
    }
}
"""

pars = SnowflakeLoginOptions("test_conn")
session = Session.builder.configs(pars).create()

# show parsed JSON from a DataFrame
df = session.create_dataframe([[jsn]], schema=["v"])
df.select(parse_json(df["v"])).show()
