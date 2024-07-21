import subprocess
from flask import Flask, render_template, request, jsonify

from functions import connect_db

sql_path = 'sql/'

app = Flask(__name__)


def read_file(param):

    if param == 'site':
        file_path = sql_path + 'table_site.sql'
    
    # Abrir e ler o arquivo
    with open(file_path, 'r') as file:
        sql_query = file.read()
    return sql_query


@app.route('/')
def index():

    # Read sql 
    sql_querie = read_file('site')
    dados = connect_db.fn_exec_querie(sql_querie)
    return render_template('index.html', dados=dados)

@app.route('/sobre')
def sobre():
    return render_template('cadastrojob.html')

@app.route('/executar_script', methods=['POST'])
def executar_script():
    data = request.get_json()
    job_id = data.get('job_id')

    sucesso = executar_meu_script(job_id)
    
    if sucesso:
        return jsonify(success=True)
    else:
        return jsonify(success=False)

def executar_meu_script(job_id):
    if job_id == '1':
        print(f"Deu certo {job_id}")
    else :
        print(f"{type(job_id)} .. {job_id}")
    try:
        result = subprocess.run(['python', 'meu_script.py', job_id], capture_output=True, text=True)
        print(result.stdout)
        return result.returncode == 0
    except Exception as e:
        print(e)
        return False
    
if __name__ == '__main__':
    app.run(debug=True, host='192.168.0.194', port=5000)
    # dados = dashboard.fn_exec_querie()
    # print(type(dados))
    # for dado in dados:
    #     print(dado)