import os

import pymysql
from dotenv import load_dotenv
from flask import Flask, redirect, render_template, request, url_for

load_dotenv()

app = Flask(__name__)


def conector_db():
    variaveis_obrigatorias = ("DB_HOST", "DB_USER", "DB_PASSWORD", "DB_NAME")
    faltantes = [nome for nome in variaveis_obrigatorias if not os.getenv(nome)]
    if faltantes:
        raise RuntimeError(
            "Configure as variáveis no arquivo .env: " + ", ".join(faltantes)
        )

    return pymysql.connect(
        host=os.environ["DB_HOST"],
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASSWORD"],
        port=int(os.getenv("DB_PORT", "3306")),
        database=os.environ["DB_NAME"],
        cursorclass=pymysql.cursors.DictCursor,
        connect_timeout=5,
    )


@app.route("/")
def home():
    return render_template("index.html")


@app.route("/esferas", methods=["GET", "POST"])
def esferas():
    if request.method == "POST":
        pedido = request.form.get("pedido", "").strip()
        if not pedido:
            return render_template("esferas.html", resultado="vazio"), 400

        conexao = conector_db()
        try:
            with conexao.cursor() as cursor:
                cursor.execute(
                    "INSERT INTO pedidos (pedido) VALUES (%s)",
                    (pedido,),
                )
            conexao.commit()
        finally:
            conexao.close()

        return redirect(url_for("esferas", resultado="ok"), code=303)

    return render_template("esferas.html", resultado="")


@app.route("/transformacoes")
def transformacoes():
    return render_template("transformacoes.html")


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)
