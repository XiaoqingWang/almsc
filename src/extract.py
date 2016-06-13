from datetime import datetime, timedelta
import numpy as np
from base import TIME_FORMAT, N_SERIES_DAYS, FEATURES
from database import connect

def _fetchall(sql):
    db = connect()
    cursor = db.cursor()
    cursor.execute(sql)
    data = np.array(cursor.fetchall())
    db.close()
    return data

def getBorder(isBegin=True, isX = True, isTrain=True):
    sql = 'select' +  (' min' if isBegin else ' max') + '(ds) from mars_tianchi_samples'
    sql += ' where is_X = \'%d\'' % (1 if isX else 0)
    sql += ' and is_train = \'%d\'' % (1 if isTrain else 0)
    data =  _fetchall(sql)
    return datetime.strptime(data[0,0], TIME_FORMAT)

def get_n_artists():
    sql = 'select count(*) from mars_tianchi_artists'
    data =  _fetchall(sql)
    return data[0,0]

def get_n_days(isX=True, isTrain=True):
    begin = getBorder(isBegin=True, isX=isX, isTrain=isTrain)
    end = getBorder(isBegin=False, isX=isX, isTrain=isTrain)
    return (end - begin).days + 1

def get_n_series():
    n_days = get_n_days(isX=False, isTrain=True)
    n_series = n_days / N_SERIES_DAYS
    n_remain_days = n_days % N_SERIES_DAYS
    return n_series if n_remain_days == 0 else n_series + 1

def getSeriesRange(i_series, isTrain=True):
    begin = getBorder(isBegin=True, isX=False, isTrain=isTrain)
    beginSeries = getBorder(isBegin=True, isX=False, isTrain=isTrain) + timedelta(days=i_series*N_SERIES_DAYS)
    assert(begin <= beginSeries)
    end = getBorder(isBegin=False, isX=False, isTrain=isTrain)
    endSeries = beginSeries + timedelta(days=N_SERIES_DAYS-1)
    endSeries = end if endSeries > end else endSeries
    return beginSeries, endSeries

def _getPlays(isTrain=True):
    sql = 'select plays from mars_tianchi_samples'
    sql += ' where is_X = 0 and is_train = %d order by artist_id, ds' % (1 if isTrain else 0)
    data = _fetchall(sql)
    return data[:,0].astype('int64')

def getFeatures(isTrain=True):
    beginY = getBorder(isBegin=True, isX=False, isTrain=isTrain)
    endY = getBorder(isBegin=False, isX=False, isTrain=isTrain)
    playsList = _getPlays(isTrain=isTrain)

    sql = 'select artist_id, ds,  %s from mars_tianchi_features' % ', '.join(FEATURES.keys())
    sql += ' where ds between \'%s\' and \'%s\' order by artist_id, ds' % (beginY.strftime(TIME_FORMAT), endY.strftime(TIME_FORMAT))

    data = _fetchall(sql)

    return data[:,0], data[:,1], data[:,2:].astype('float64'), playsList

def getSeries(name, begin=None, end=None):
    assert(begin is not None and end is not None)
    sql = 'select artist_id, val from mars_tianchi_series where name = \'%s\' and ds between \'%s\' and \'%s\' order by artist_id, ds' % (name, begin.strftime(TIME_FORMAT), end.strftime(TIME_FORMAT))
    data =  _fetchall(sql)
    return data[:,0], data[:,1].astype('float64')

def getArtistIdList():
    sql = 'select artist_id from mars_tianchi_artists'
    data =  _fetchall(sql)
    return data[:,0]

def getPlays(isTrain=True):
    return _getPlays(isTrain=isTrain)

def getPredict(recordId):
    sql = 'select * from mars_tianchi_artist_plays_predict where record_id = \'%s\' order by artist_id, ds' % recordId
    data = _fetchall(sql)
    return data[:,1:]
