# paste and run in a Python Worksheet
import snowflake.snowpark as snowpark

def main(session: snowpark.Session): 
    dataframe = session.table('store')
    dataframe.show()
    return dataframe