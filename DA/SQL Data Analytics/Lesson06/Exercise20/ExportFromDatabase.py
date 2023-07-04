import psycopg2
with psycopg2.connect(host="localhost", user="postgres", password="Kaplan123", dbname="zoomzoom", port=5432)as conn:
    with conn.cursor() as cur:
        cur.execute("select * from customers limit 5")
        records = cur.fetchall()
for row in records:
    print(row)