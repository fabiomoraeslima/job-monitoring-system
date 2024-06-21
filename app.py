from flask import Flask, render_template
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


if __name__ == '__main__':
    app.run(debug=True, host='192.168.0.194', port=5000)
    # dados = dashboard.fn_exec_querie()
    # print(type(dados))
    # for dado in dados:
    #     print(dado)