import psycopg
from faker import Faker
import uuid
import asyncio

FAKE = Faker()

RDS_ENDPOINT =  'http://localhost.localstack.cloud:4566'


async def create_table():
    conn = await psycopg.AsyncConnection.connect("dbname=rds_postgres_cluster_test user=test password='test' host=localhost port=4510")

    async with conn.cursor() as cur:
        await cur.execute('CREATE TABLE person ("id" VARCHAR not null, "name" VARCHAR not null, PRIMARY KEY ("id"))')
    await conn.commit()
    

async def create_random_person(cur):
     await cur.execute(f"INSERT INTO person VALUES ('{str(uuid.uuid4())}', '{FAKE.name()}')")

async def populate_table():
    conn = await psycopg.AsyncConnection.connect("dbname=rds_postgres_cluster_test user=test password='test' host=localhost port=4510")
    async with conn.cursor() as cur:
            create_all_people = [create_random_person(cur) for i in range(1000)]
            await asyncio.gather(*create_all_people)
            
    await conn.commit()

async def select_all_from_table():
    conn = await psycopg.AsyncConnection.connect("dbname=rds_postgres_cluster_test user=test password='test' host=localhost port=4510" )

    async with conn.cursor() as cur:
        await cur.execute("SELECT * FROM person LIMIT 40")
        result = await cur.fetchall()
        print(result)


async def main():
    await create_table()
    await populate_table()
    await select_all_from_table()

if __name__ == '__main__':
    asyncio.run(main())