import MySQLdb
from base import HOST, USER, PASSWORD, DATABASE


def connect():
    return MySQLdb.connect(HOST, USER, PASSWORD, DATABASE)
