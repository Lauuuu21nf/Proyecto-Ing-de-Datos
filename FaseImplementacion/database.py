import mysql.connector
from pymongo import MongoClient

# ─── MYSQL ───────────────────────────────────────────────
def conectar_mysql():
    try:
        conexion = mysql.connector.connect(
            host="localhost",
            user="root",           
            password="Ls1924na#",   
            database="sst_tgi"       
        )
        print("MySQL: Conexión exitosa")
        return conexion
    except Exception as e:
        print(f"MySQL: Error de conexión → {e}")
        return None

def conectar_mongo():
    try:
        cliente = MongoClient("mongodb://localhost:27017")
        cliente.server_info()
        print("MongoDB: Conexión exitosa")
        return cliente
    except Exception as e:
        print(f"MongoDB: Error de conexión → {e}")
        return None


if __name__ == "__main__":
    conectar_mysql()
    conectar_mongo()