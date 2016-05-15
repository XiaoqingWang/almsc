#!/usr/bin/env python

from datetime import datetime
from datetime import timedelta
import numpy as np
from base import N_SERIES_DAYS, TIME_FORMAT
from database import connect
from extract import getBorder, get_n_days, get_n_artists, get_n_series, getSeries, getSeriesRange

def genFeatureDefination(name):
    db = connect()
    cursor = db.cursor()
    sql = 'alter table mars_tianchi_features drop column %s' % name
    try:
        cursor.execute(sql)
    except Exception, e:
        print 'ignore drop column error !!!'
    sql = 'alter table mars_tianchi_features add column (%s float)' % name
    cursor.execute(sql)

    beginXTrain = getBorder(isBegin=True, isX=True, isTrain=True)
    endXTrain = getBorder(isBegin=False, isX=True, isTrain=True)
    beginXTest = getBorder(isBegin=True, isX=True, isTrain=False)
    endXTest = getBorder(isBegin=False, isX=True, isTrain=False)
    beginYTrain = getBorder(isBegin=True, isX=False, isTrain=True)
    endYTrain = getBorder(isBegin=False, isX=False, isTrain=True)
    n_X_days = get_n_days(isX=True, isTrain=True)
    n_y_days = get_n_days(isX=False, isTrain=True)
    n_artists = get_n_artists()
    n_series = get_n_series()
    artistIdList, playsTrainList = getSeries('s_plays', begin=beginYTrain, end=endYTrain)
    artistIdList, valTrainList = getSeries(name, begin=beginXTrain, end=endXTrain)
    artistIdList, valTestList = getSeries(name, begin=beginXTest, end=endXTest)

    for i in range(n_artists):
        artistId = artistIdList[i*n_y_days]
        print '[artist]', name, artistId, i

        for j in range(n_series):
            beginSeriesTrain, endSeriesTrain = getSeriesRange(j, isTrain=True) 
            beginSeriesTest, endSeriesTest = getSeriesRange(j, isTrain=False) 
            n_series_days = (endSeriesTrain - beginSeriesTrain).days + 1

            best_corr = -1 
            offset_to_endXTrain = -n_series_days
            while True:
                beginVal = endXTrain + timedelta(days=offset_to_endXTrain+1)
                if beginVal < beginXTrain:
                    break

                playsSeries = playsTrainList[i*n_y_days+j*N_SERIES_DAYS:i*n_y_days+j*N_SERIES_DAYS+n_series_days]
#                print '[plays]', beginSeriesTrain, endSeriesTrain, playsSeries
                meanPlaysSeries  = np.mean(playsSeries)
                stdPlaysSeries  = np.std(playsSeries)
                playsSeries = (playsSeries - meanPlaysSeries) / stdPlaysSeries if stdPlaysSeries != 0.0 else 0.0
#                print '[plays]', meanPlaysSeries, stdPlaysSeries

                valSeries = valTrainList[(i+1)*n_X_days+offset_to_endXTrain:(i+1)*n_X_days+offset_to_endXTrain+n_series_days]
#                print '[val]', offset_to_endXTrain, beginVal, valSeries, (i+1)*n_X_days+offset_to_endXTrain
                meanValSeries  = np.mean(valSeries)
                stdValSeries  = np.std(valSeries)
                valSeries = (valSeries - meanValSeries) / stdValSeries if stdValSeries != 0.0 else 0.0
#                print '[val]', meanValSeries, stdValSeries

                corrcoef = abs(np.corrcoef([playsSeries, valSeries])[0,1] if stdPlaysSeries != 0.0 and stdValSeries != 0.0 else 0.0)
                if corrcoef > best_corr:
                    best_corr = corrcoef
                    best_offset = (beginVal - beginSeriesTrain).days
                offset_to_endXTrain -= 1

            sql = 'update mars_tianchi_features set %s = (select val from mars_tianchi_series where mars_tianchi_series.artist_id = mars_tianchi_features.artist_id and mars_tianchi_series.name = \'%s\' and datediff(mars_tianchi_series.ds, mars_tianchi_features.ds) = %d) where mars_tianchi_features.artist_id = \'%s\' and (mars_tianchi_features.ds between \'%s\' and \'%s\' or mars_tianchi_features.ds between \'%s\' and \'%s\')' % (name, name, best_offset, artistId, beginSeriesTrain.strftime(TIME_FORMAT), endSeriesTrain.strftime(TIME_FORMAT), beginSeriesTest.strftime(TIME_FORMAT), endSeriesTest.strftime(TIME_FORMAT))
            cursor.execute(sql)
        
    db.commit()
    db.close()

def main():
#    genFeatureDefination('s_plays')
#    genFeatureDefination('s_avg_plays_last_3_days')
#    genFeatureDefination('s_avg_plays_last_5_days')
#    genFeatureDefination('s_avg_plays_last_7_days')
#    genFeatureDefination('s_downloads')
#    genFeatureDefination('s_avg_downloads_last_3_days')
#    genFeatureDefination('s_avg_downloads_last_5_days')
#    genFeatureDefination('s_avg_downloads_last_7_days')
#    genFeatureDefination('s_collects')
#    genFeatureDefination('s_avg_collects_last_3_days')
#    genFeatureDefination('s_avg_collects_last_5_days')
#    genFeatureDefination('s_avg_collects_last_7_days')
#    genFeatureDefination('s_diff_plays')
#    genFeatureDefination('s_diff_downloads')
#    genFeatureDefination('s_diff_collects')
#    genFeatureDefination('s_plays_div_plays_prev_1_days')
#    genFeatureDefination('s_plays_div_plays_prev_2_days')
#    genFeatureDefination('s_plays_div_plays_prev_4_days')
#    genFeatureDefination('s_plays_div_plays_prev_6_days')
#    genFeatureDefination('s_plays_div_downloads')
#    genFeatureDefination('s_plays_div_downloads_last_3_days')
#    genFeatureDefination('s_plays_div_downloads_last_5_days')
#    genFeatureDefination('s_plays_div_downloads_last_7_days')
#    genFeatureDefination('s_plays_div_collects')
#    genFeatureDefination('s_plays_div_collects_last_3_days')
#    genFeatureDefination('s_plays_div_collects_last_5_days')
#    genFeatureDefination('s_plays_div_collects_last_7_days')
#    genFeatureDefination('s_play_users')
#    genFeatureDefination('s_avg_play_users_last_3_days')
#    genFeatureDefination('s_avg_play_users_last_5_days')
#    genFeatureDefination('s_avg_play_users_last_7_days')
#    genFeatureDefination('s_users')
#    genFeatureDefination('s_new_users')
#    genFeatureDefination('s_new_users_div_users')
#    genFeatureDefination('s_diff_users')
    genFeatureDefination('s_new_plays')
    genFeatureDefination('s_new_plays_div_plays')

if __name__ == '__main__':
    main()
