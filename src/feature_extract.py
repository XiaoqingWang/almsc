import numpy as np
from base import connect

_features = ['month', 'day', 'season', 'week', 'weekday', 'holiday', 'n_holidays', 'i_holidays', 'plays_last_1_week', 'plays_last_2_week', 'plays_last_3_week', 'plays_last_4_week', 'plays_last_5_week']
#_features = ['month', 'day', 'season', 'week', 'weekday', 'holiday', 'n_holidays', 'i_holidays']


def feature(isTrain=True):
    sql = 'select artist_id, ds, plays, %s from mars_tianchi_features where is_train = \'%s\' order by artist_id, ds' % (', '.join(_features), '1' if isTrain else '0')
    db = connect()
    cursor = db.cursor()
    cursor.execute(sql)
    data = np.array(cursor.fetchall())
    db.close()
    return (data[:,[0,1]], data[:,3:].astype('float64'), data[:,2].astype('int64'))
