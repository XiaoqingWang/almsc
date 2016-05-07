import MySQLdb

_host = 'almsc'
_user = 'root'
_password = 'Almsc@2016'
_database = 'almsc'

def connect():
    return MySQLdb.connect(_host, _user, _password, _database)
