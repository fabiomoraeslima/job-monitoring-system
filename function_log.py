import mysql.connector

def fn_exec_querie(sql):

    # Conectar ao MySQL
    mydb = mysql.connector.connect(
    host="192.168.0.226",
    user="svc_report",
    password="report",
    database="suporte"
    )

    # Criar um cursor para executar consultas
    cursor = mydb.cursor()

    # Executar uma consulta
    cursor.execute(sql)
    
    try:
        # Commit para confirmar a transação
        mydb.commit()
    except:
        pass 

    # Obter os resultados
    resultados = cursor.fetchall()

    # Fechar o cursor e a conexão
    cursor.close()
    mydb.close()

    return resultados


def fn_start_process(job_id, status = 2, mensagem=''):

    # Script para validar se o Job está em execução
    sql = f""" select * from log_execucao where job_id = '{job_id}' and data_hora_fim is null """

    # Script de insert com inicio do Processo 
    insert_sql = f""" insert into log_execucao (job_id, data_hora_inicio, status, mensagem) 
                    values ({job_id},CONVERT_TZ(NOW(), 'UTC', 'America/Sao_Paulo'),'{status}','{mensagem}');
    """

    if fn_exec_querie(sql):
        return print('*** Atencao ultima execução nao finalizada !!**')
    else :
        fn_exec_querie(insert_sql)
        return print("Processo Iniciado")

def fn_end_process(job_id, status = 3, mensagem=''):

    update_sql = f""" update log_execucao 
                        set data_hora_fim = CONVERT_TZ(NOW(), 'UTC', 'America/Sao_Paulo'),
                            status = {status},
                            mensagem = '{mensagem}' 
                        where job_id = '{job_id}' and data_hora_fim is null """

    fn_exec_querie(update_sql)

    return print("Processo Finalizado com sucesso") 