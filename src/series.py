#!/usr/bin/env python

from datetime import datetime
from datetime import timedelta
import numpy as np
from base import n_artists, n_days as base_n_days
from database import connect
from extract import border, series

def correlation(name, min_offset=-60, n_days=7):
    db = connect()
    cursor = db.cursor()
    sql = 'delete from mars_tianchi_series_correlation where name = \'%s\'' % name
    cursor.execute(sql)
    begin = datetime.strptime(border(isBegin=True, isTrain=True), '%Y%m%d')
    end= datetime.strptime(border(isBegin=False, isTrain=True), '%Y%m%d')


    for i in range(n_artists):
        artist_ids, days, names, plays = series('plays')
        artist_id = artist_ids[i*base_n_days]
        name = names[i*base_n_days]

        best_corr = -1 
        offset = -n_days
        while offset > min_offset:

            valsSeriesBegin = begin + timedelta(days=offset)
            valsSeriesEnd = valsSeriesBegin + timedelta(days=n_days-1)
            strValsSeriesBegin = valsSeriesBegin.strftime('%Y%m%d')
            strValsSeriesEnd = valsSeriesEnd.strftime('%Y%m%d')
            artist_ids, days, names, vals = series(name, begin=strValsSeriesBegin, end=strValsSeriesEnd)

            corrcoef = 0
            n_series = 0
            playsSeriesBegin = begin
            while playsSeriesBegin <= end:
                playsSeriesEnd = playsSeriesBegin + timedelta(days=n_days-1)
                playsSeriesEnd = end if playsSeriesEnd > end else playsSeriesEnd

                n_seriesDays = (playsSeriesEnd - playsSeriesBegin).days + 1

                strPlaysSeriesBegin = playsSeriesBegin.strftime('%Y%m%d')
                strPlaysSeriesEnd = playsSeriesEnd.strftime('%Y%m%d')


                seriesVals = vals[i*n_days:i*n_days+n_seriesDays]
                valsMean = np.mean(seriesVals)
                valsStd = np.std(seriesVals)
                seriesVals = (seriesVals - valsMean) / valsStd if valsStd != 0.0 else np.zeros(n_seriesDays)

                seriesPlays = plays[i*base_n_days+n_series*n_days:i*base_n_days+n_series*n_days+n_seriesDays]
                playsMean = np.mean(seriesPlays)
                playsStd = np.std(seriesPlays)
                seriesPlays = (seriesPlays - playsMean) / playsStd if playsStd != 0.0 else np.zeros(n_seriesDays)

                corrcoef += np.corrcoef([seriesPlays, seriesVals])[0,1] if valsStd != 0.0 and playsStd != 0.0 else 0.0
                n_series += 1
                playsSeriesBegin += timedelta(days=n_days)

            corrcoef /= n_series
            if abs(corrcoef) > best_corr:
                best_corr = abs(corrcoef)
                best_offset = offset

            offset -= 1
        sql = 'insert into mars_tianchi_series_correlation values(\'%s\', \'%s\', %d,  %d, %f)' % (artist_id, name, n_days, best_offset, best_corr)
        print '[artist]', i, artist_id
        cursor.execute(sql)
    db.commit()
    db.close()

def main():
    correlation('plays')

if __name__ == '__main__':
    main()
