import pymysql
from flask import Flask, render_template

app = Flask(__name__)

# Cria uma conexao com o banco de dados; este bloco nao chama uma pagina.
def conector_db():
    return pymysql.connect (
        host='localhost',
        user='root',
        password='sua_senha',
        port='3306',
        database='escola',
        cursorclass=pymysql.cursors.DictCursor,
        connect_timeout=5
    )

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/esferas")
def esferas():
    return render_template("esferas.html")

@app.route("/transformacoes")
def transformacoes():
    return render_template("transformacoes.html")

# Inicia o servidor Flask quando este arquivo e executado diretamente.
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)
