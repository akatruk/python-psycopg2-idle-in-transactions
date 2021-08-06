from flask import Flask, render_template, request, flash, redirect, jsonify, render_template_string
import psycopg2, sys, os

app = Flask(__name__)
idle = 'scripts/idle_in_transaction.sql'
detail = 'scripts/detail.sql'
version = 'scripts/pg_version.sql'
locks = 'scripts/locks.sql'
locks_kill = 'scripts/locks_kill.sql'
list_connections = 'scripts/list_connections.sql'
c_locks = 'scripts/c_locks.sql'
locks_error = 'Not any hightweght locks'
t1 = ('Days', 'Hours', 'Minutes', 'Database name', 'PID', 'Wait event', 'source ip', 'Query')
t2 = ('ts_age', 'state', 'change_age', 'datname', 'pid', 'username','client_addr','lvl','blocked','query')


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
    _result, error = get_data(_srv,_login,_pwd,_dbname,detail)
    _result1, error = get_data(_srv,_login,_pwd,_dbname,idle)
    _result2, error = get_data(_srv,_login,_pwd,_dbname,locks)
    _result3, error = get_data(_srv,_login,_pwd,_dbname,locks_kill)
    _result4, error = get_data(_srv,_login,_pwd,_dbname,list_connections)
    _result5, error = get_data(_srv,_login,_pwd,_dbname,c_locks)
    first_tuple_elements = [a_tuple[0] for a_tuple in _result5]
    _result_fatal, error_fatal = get_data(_srv,_login,_pwd,_dbname,version)
    if error_fatal:
        return render_template('output_fatal.html', error_fatal=_result_fatal)
    elif error:
        return render_template('output_fatal.html', error_fatal=error)
    else:
        if first_tuple_elements[0] >= 1:
            return render_template('output.html', tt1=t1, tt2=t2, data1=_result, data2=_result1, data3=_result2, data4=_result3, data5=_result4)
        else:
            return render_template('output_error.html', tt1=t1, tt2=t2, data1=_result, data2=_result1, data3=_result2, data4=_result3, data5=_result4)


if __name__ == '__main__':
    app.run(debug=True,host="0.0.0.0", port=80)