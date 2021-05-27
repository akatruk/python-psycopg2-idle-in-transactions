from flask import Flask, render_template, request, flash, redirect, jsonify, render_template_string
import psycopg2, sys, os

app = Flask(__name__)
f1 = 'scripts/idle_in_transaction.sql'
f2 = 'scripts/detail.sql'
t1 = ('Database name', 'PID', 'source ip', 'Query')

def read_file(text):
    with open(text, 'r') as r1:
        return r1.read()

def get_data(srv, login, pwd, dbname, files):
    con = None

    try:

        con = psycopg2.connect(dbname=dbname, user=login, host=srv, password=pwd)

        cur = con.cursor()
        cur.execute(read_file(files))

        version = cur.fetchall()
        return version, False

    except psycopg2.DatabaseError as e:

        return f'Error {e}', True

    finally:

        if con:
            con.close()

@app.route('/')
def index():
        return render_template('index.html')

@app.route('/output', methods=['POST'])
def output():
    _login = request.form['login']
    _srv = request.form['srv_name']
    _pwd = request.form['passwd']
    _dbname = request.form['dbname']
    _result, error = get_data(_srv,_login,_pwd,_dbname, f2)
    if error:
        return render_template('output_error.html', data1=_result)
    else:
        return render_template('output.html', tt1=t1, data1=_result)

if __name__ == '__main__':
    app.run(debug=True,host="0.0.0.0", port=80)