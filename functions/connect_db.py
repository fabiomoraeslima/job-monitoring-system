import mysql.connector
import os 
from dotenv import load_dotenv, find_dotenv

_ = load_dotenv(find_dotenv())

def fn_exec_querie(sql):

    # Conectar ao MySQL
    mydb = mysql.connector.connect(
    host = os.getenv("MYSQL_HOST"),
    user = os.getenv("MYSQL_USER"),
    password = os.getenv("MYSQL_PASSWORD"),
    database= os.getenv("MYSQL_DATABASE")
    )

    # Criar um cursor para executar consultas
    cursor = mydb.cursor()

    # Executar uma consulta
    cursor.execute(sql)

    # Obter os resultados
    resultados = cursor.fetchall()

    # Fechar o cursor e a conexão
    cursor.close()
    mydb.close()

    return resultados
