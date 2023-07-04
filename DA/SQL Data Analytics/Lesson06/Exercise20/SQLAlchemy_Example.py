from sqlalchemy import create_engine
import pandas as pd

cnx_string = "postgresql+psycopg2://{username}:{pswd}@{host}:{port}/{database}"
print (cnx_string)

engine = create_engine( cnx_string.format(
    username = "postgres",
    pswd = "Kaplan123",
    host = "localhost",
    port = 5432,
    database = "zoomzoom"
))

records = engine.execute("select * from customers limit 2;").fetchall()

for row in records:
    print(row)
