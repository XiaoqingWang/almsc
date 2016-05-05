import numpy as np
import MySQLdb

_host = 'localhost'
_user = 'root'
_password = 'Almsc@2016'
_database = 'almsc'
_features = ['month', 'day', 'season', 'weekday']
_range_train = '20150501 and 20150630'
_range_test = '20150701 and 20150830'

def feature(isTrain=True):
    sql = 'select artist_id, ds, plays, %s from mars_tianchi_features where ds between %s order by artist_id, ds' % (', '.join(_features), _range_train if isTrain else _range_test)
    db = MySQLdb.connect(_host, _user, _password, _database)
    cursor = db.cursor()
    cursor.execute(sql)
    data = np.array(cursor.fetchall())
    db.close()
    return (data[:,[0,1]], data[:,2].astype('int64'), data[:,3:].astype('float64'))
