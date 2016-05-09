import numpy as np
from database import connect

_features = {'month': True, 'day':True, 'season':True, 'week':True, 'weekday':True, 'is_holiday':False, 'n_holidays':True, 'i_holidays':True, 'is_good_voice':False, 'is_music_festival':False,
'artist_code':True, 'plays_last_1_week':False, 'plays_last_2_week':False, 'plays_last_3_week':False, 'plays_last_4_week':False, 'plays_last_5_week':False, 
'n_songs':False, 'gender':True, 'n_languages':False, 'mode_language':False,
'avg_artist_song_plays_last_1_month':False, 'std_artist_song_plays_last_1_month':False, 'avg_artist_song_plays_last_2_month':False, 'std_artist_song_plays_last_2_month':False,
'offset_first_song':False, 'offset_last_song':False, 
'avg_plays_same_weekday':False, 'avg_plays_same_day':False, 'qoq_plays_last_1_week':False, 'qoq_plays_last_2_week':False, 'qoq_plays_last_3_week':False, 'yoy_plays':False}

def encoder_list():
    idx_list = range(len(_features))
    values = _features.values()
    return filter(lambda x:values[x], idx_list)

def fetchall(sql):
    db = connect()
    cursor = db.cursor()
    cursor.execute(sql)
    data = np.array(cursor.fetchall())
    db.close()
    return data

def border(isBegin=True, isTrain=True):
    sql = 'select' +  (' min' if isBegin else ' max') + '(ds) from mars_tianchi_features'
    sql += ' where is_train = \'%d\'' % (1 if isTrain else 0)
    data =  fetchall(sql)
    return data[0,0]

def feature(isTrain=True):
    sql = 'select artist_id, ds, plays, %s from mars_tianchi_features where is_train = \'%d\' order by artist_id, ds' % (', '.join(_features.keys()), 1 if isTrain else 0)
    data = fetchall(sql)
    return (data[:,[0,1]], data[:,3:].astype('float64'), data[:,2].astype('int64'))

def artist(begin=None, end=None, actionType=1):
    sql = 'select artist_id, sum(n) as plays from mars_tianchi_artist_actions where action_type = \'%d\'' % actionType
    if begin: sql += ' and \'%s\' <= ds' % begin
    if end: sql += ' and ds <= \'%s\'' % end
    sql += ' group by artist_id'
    data = fetchall(sql)
    return (data[:,0], data[:,1].astype('float64'))

def day(begin=None, end=None, actionType=1):
    sql = 'select ds, sum(n) as plays from mars_tianchi_artist_actions where action_type = \'%d\'' % actionType
    if begin: sql += ' and \'%s\' <= ds' % begin
    if end: sql += ' and ds <= \'%s\'' % end
    sql += ' group by ds'
    data = fetchall(sql)
    return (data[:,0], data[:,1].astype('float64'))

def artist_day(begin=None, end=None, actionType=1):
    sql = 'select artist_id, ds, n as plays from mars_tianchi_artist_actions where action_type = \'%d\'' % actionType
    if begin: sql += ' and \'%s\' <= ds' % begin
    if end: sql += ' and ds <= \'%s\'' % end
    data = fetchall(sql)
    return (data[:,0], data[:,1], data[:,2].astype('float64'))

