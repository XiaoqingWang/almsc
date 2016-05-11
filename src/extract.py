from datetime import datetime, timedelta
import numpy as np
from base import TIME_FORMAT, N_SERIES_DAYS, MIN_CORRELATION, IS_CATEGORY
from database import connect

def _getEncoderList(isCategoryList):
    encoderList = range(isCategoryList.size)
    encoderList = filter(lambda x:isCategoryList[x] == 1.0, encoderList)
    return encoderList

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
    return n_days / N_SERIES_DAYS + 1

def getSeriesRange(i_series, isTrain=True):
    begin = getBorder(isBegin=True, isX=False, isTrain=isTrain)
    beginSeries = getBorder(isBegin=True, isX=False, isTrain=isTrain) + timedelta(days=i_series*N_SERIES_DAYS)
    assert(begin <= beginSeries)
    end = getBorder(isBegin=False, isX=False, isTrain=isTrain)
    endSeries = beginSeries + timedelta(days=N_SERIES_DAYS-1)
    endSeries = end if endSeries > end else endSeries
    return beginSeries, endSeries

def _getPlays(artistId, begin=None, end=None, isX=True, isTrain=True):
    assert(begin is not None and end is not None)
    sql = 'select plays from mars_tianchi_samples'
    sql += ' where artist_id = \'%s\' and ds between \'%s\' and \'%s\' and is_X = %d and is_train = %d order by ds' % (artistId, begin.strftime(TIME_FORMAT), end.strftime(TIME_FORMAT), isX, isTrain)
    data = _fetchall(sql)
    return data[:,0].astype('int64')

def _getFeatureDefinations(artistId, i_series, minCorrelation=MIN_CORRELATION):
    sql = 'select name, is_category, offset from mars_tianchi_feature_definations'
    sql += ' where artist_id = \'%s\' and i_series = %d and correlation >= %f' % (artistId, i_series, minCorrelation)
    data = _fetchall(sql)
    return data[:,0], data[:,1].astype('int64'), data[:,2].astype('int64')

def getFeatures(artistId, i_series, isTrain=True):
    beginSeries, endSeries = getSeriesRange(i_series, isTrain=isTrain)
    playsList = _getPlays(artistId, begin=beginSeries, end=endSeries, isX=False, isTrain=isTrain)

    #normal features
    normalFeatures = None
    sql = 'select * from mars_tianchi_features'
    sql += ' where artist_id = \'%s\' and ds between \'%s\' and \'%s\'' % (artistId, beginSeries.strftime(TIME_FORMAT), endSeries.strftime(TIME_FORMAT))
    data = _fetchall(sql)
    normalFeatures = data[:,2:].astype('float64')

    #series features
    seriesFeatures = None
    nameList, isCategoryList, offsetList = _getFeatureDefinations(artistId, i_series)
    n_features =  nameList.size
    for i in range(n_features):
        name = str(nameList[i])
        offset = int(offsetList[i])
        beginVals = beginSeries + timedelta(days=offset)
        endVals = endSeries + timedelta(days=offset)
        sql = 'select val from mars_tianchi_series where artist_id = \'%s\' and name = \'%s\' and ds between \'%s\' and \'%s\' order by ds' % (artistId, name, beginVals.strftime(TIME_FORMAT), endVals.strftime(TIME_FORMAT))
        data = _fetchall(sql)
        seriesFeatures = data.reshape(-1,1) if seriesFeatures is None else np.hstack((seriesFeatures, data.reshape(-1,1)))

    assert(normalFeatures is not None or seriesFeatures is not None)
    if normalFeatures is None:
        features = seriesFeatures
    elif seriesFeatures is None:
        features = normalFeatures
    else:
        features = np.hstack((normalFeatures, seriesFeatures))

    isCategoryList = np.hstack((IS_CATEGORY, isCategoryList))

    return features, playsList, _getEncoderList(isCategoryList)

def getSeries(name, begin=None, end=None):
    assert(begin is not None and end is not None)
    sql = 'select artist_id, val from mars_tianchi_series where name = \'%s\' and ds between \'%s\' and \'%s\' order by artist_id, ds' % (name, begin.strftime(TIME_FORMAT), end.strftime(TIME_FORMAT))
    data =  _fetchall(sql)
    return data[:,0], data[:,1].astype('float64')

def getArtistIdList():
    sql = 'select artist_id from mars_tianchi_artists'
    data =  _fetchall(sql)
    return data[:,0]
