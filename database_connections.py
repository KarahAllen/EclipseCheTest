import os
import psycopg2
from pymongo import MongoClient
from psycopg2.extras import RealDictCursor
from dotenv import load_dotenv
load_dotenv()
# -----------------------------
# Load environment variables
# -----------------------------
MONGO_URI = os.getenv("MONGO_URI")  # e.g. "mongodb://user:pass@mongo.example.com:27017/dbname"
POSTGRES_HOST = os.getenv("POSTGRES_HOST")  # e.g. "postgres.example.com"
POSTGRES_DB = os.getenv("POSTGRES_DB")
POSTGRES_USER = os.getenv("POSTGRES_USER")
POSTGRES_PASSWORD = os.getenv("POSTGRES_PASSWORD")
POSTGRES_PORT = os.getenv("POSTGRES_PORT", "5432")

# -----------------------------
# Connect to MongoDB
# -----------------------------
def connect_mongo():
    try:
        client = MongoClient(MONGO_URI, serverSelectionTimeoutMS=5000)
        db = client.get_default_database()
        print("✅ Connected to MongoDB:", db.name)
        return db
    except Exception as e:
        print("❌ MongoDB connection failed:", e)
        return None

# -----------------------------
# Connect to PostgreSQL
# -----------------------------
def connect_postgres():
    try:
        conn = psycopg2.connect(
            host=POSTGRES_HOST,
            dbname=POSTGRES_DB,
            user=POSTGRES_USER,
            password=POSTGRES_PASSWORD,
            port=POSTGRES_PORT,
            cursor_factory=RealDictCursor
        )
        print("✅ Connected to PostgreSQL:", POSTGRES_DB)
        return conn
    except Exception as e:
        print("❌ PostgreSQL connection failed:", e)
        return None

# -----------------------------
# Example queries
# -----------------------------
if __name__ == "__main__":
    mongo_db = connect_mongo()
    pg_conn = connect_postgres()

    if pg_conn is not None:
        with pg_conn.cursor() as cur:
            cur.execute("SELECT NOW();")
            print("PostgreSQL Time:", cur.fetchone())
        pg_conn.close()

    if mongo_db is not None:
        print("MongoDB Collections:", mongo_db.list_collection_names())
