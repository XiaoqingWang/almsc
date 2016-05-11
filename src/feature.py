#!/usr/bin/env python

from datetime import datetime
from datetime import timedelta
import numpy as np
from base import N_SERIES_DAYS
from database import connect
from extract import getBorder, get_n_days, get_n_artists, get_n_series, getSeries, getSeriesRange

def genFeatureDefination(name, isCategory=True):
    db = connect()
    cursor = db.cursor()
    sql = 'delete from mars_tianchi_feature_definations where name = \'%s\'' % name
    cursor.execute(sql)
    db.commit()

    beginX = getBorder(isBegin=True, isX=True, isTrain=True)
    endX = getBorder(isBegin=False, isX=True, isTrain=True)
    beginY = getBorder(isBegin=True, isX=False, isTrain=True)
    endY = getBorder(isBegin=False, isX=False, isTrain=True)
    n_X_days = get_n_days(isX=True, isTrain=True)
    n_y_days = get_n_days(isX=False, isTrain=True)
    n_artists = get_n_artists()
    n_series = get_n_series()
    artistIdList, playsList = getSeries('plays', begin=beginY, end=endY)
    artistIdList, valList = getSeries(name, begin=beginX, end=endX)

    for i in range(n_artists):
        artistId = artistIdList[i*n_y_days]
        print '[artist]', name, artistId, i

        for j in range(n_series):
            beginSeries, endSeries = getSeriesRange(j, isTrain=True) 
            n_series_days = (endSeries - beginSeries).days + 1

            best_corr = -1 
            offset_to_endX = -n_series_days
            while True:
                beginVal = beginY + timedelta(days=offset_to_endX)
                if beginVal < beginX:
                    break

                playsSeries = playsList[i*n_y_days+j*N_SERIES_DAYS:i*n_y_days+j*N_SERIES_DAYS+n_series_days]
#                print '[plays]', playsSeries
                meanPlaysSeries  = np.mean(playsSeries)
                stdPlaysSeries  = np.std(playsSeries)
                playsSeries = (playsSeries - meanPlaysSeries) / stdPlaysSeries if stdPlaysSeries != 0.0 else 0.0
#                print '[plays]', meanPlaysSeries, stdPlaysSeries

                valSeries = valList[(i+1)*n_X_days+offset_to_endX:(i+1)*n_X_days+offset_to_endX+n_series_days]
#                print '[val]', valSeries
                meanValSeries  = np.mean(valSeries)
                stdValSeries  = np.std(valSeries)
                valSeries = (valSeries - meanValSeries) / stdValSeries if stdValSeries != 0.0 else 0.0
#                print '[val]', meanValSeries, stdValSeries

                corrcoef = abs(np.corrcoef([playsSeries, valSeries])[0,1] if stdPlaysSeries != 0.0 and stdValSeries != 0.0 else 0.0)
                if corrcoef > best_corr:
                    best_corr = corrcoef
                    best_offset = (beginVal - beginSeries).days
                offset_to_endX -= 1

            sql = 'insert into mars_tianchi_feature_definations values(\'%s\', \'%s\', %d, %d, %d, %f)' % (artistId, name, 1 if isCategory else 0, j, best_offset, best_corr)
            cursor.execute(sql)
            db.commit()
        
    db.close()

def main():
    genFeatureDefination('plays', isCategory=False)
    genFeatureDefination('avg_plays_last_7_days', isCategory=False)
    genFeatureDefination('diff_plays', isCategory=False)
    genFeatureDefination('collects', isCategory=False)
    genFeatureDefination('downloads', isCategory=False)

if __name__ == '__main__':
    main()
