import mysql.connector

def fn_exec_querie(sql):

    # Conectar ao MySQL
    mydb = mysql.connector.connect(
    host="hostname",
    user="svc_report",
    password="report",
    database="suporte"
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
