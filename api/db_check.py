import psycopg
import os

with psycopg.connect(dbname="finance", user="arsha", password=os.environ["DB_PASSWORD"]) as conn:
    # everything that uses the database goes in here, indented
    cur = conn.execute("SELECT * FROM transactions ORDER BY id LIMIT 5")
    for row in cur.fetchall():
        print(row)

        
