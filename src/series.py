#!/usr/bin/env python

from datetime import datetime
from datetime import timedelta
import numpy as np
from base import n_artists
from database import connect
from extract import border, series

def correlation(name, min_offset=-60, n_days=7):
    db = connect()
    cursor = db.cursor()
    sql = 'delete from mars_tianchi_series_correlation where name = \'%s\'' % name
    cursor.execute(sql)
    begin = datetime.strptime(border(isBegin=True, isTrain=True), '%Y%m%d')
    end= datetime.strptime(border(isBegin=False, isTrain=True), '%Y%m%d')
    playsSeriesBegin = begin
    while playsSeriesBegin <= end:
        playsSeriesEnd = playsSeriesBegin + timedelta(days=n_days-1)
        playsSeriesEnd = end if playsSeriesEnd > end else playsSeriesEnd
        n_seriesDays = (playsSeriesEnd - playsSeriesBegin).days + 1
        strPlaysSeriesBegin = playsSeriesBegin.strftime('%Y%m%d')
        strPlaysSeriesEnd = playsSeriesEnd.strftime('%Y%m%d')
        artist_ids, days, names, plays = series('plays', begin=strPlaysSeriesBegin, end=strPlaysSeriesEnd)

        for i in range(n_artists):
            artist_id = artist_ids[i*n_seriesDays]
            name = names[i*n_seriesDays]

            best_corr = -1 
            offset = -n_days
            while offset > min_offset:
                valsSeriesBegin = begin + timedelta(days=offset)
                valsSeriesEnd = valsSeriesBegin + timedelta(days=n_seriesDays-1)
                strValsSeriesBegin = valsSeriesBegin.strftime('%Y%m%d')
                strValsSeriesEnd = valsSeriesEnd.strftime('%Y%m%d')
                artist_ids, days, names, vals = series(name, begin=strValsSeriesBegin, end=strValsSeriesEnd)
#                print plays.shape, vals.shape
#                print i, n_days, n_seriesDays
                abs_corrcoef = abs(np.corrcoef([plays[i*n_seriesDays:(i+1)*n_seriesDays], vals[i*n_seriesDays:(i+1)*n_seriesDays]])[0,1])
                if abs_corrcoef > best_corr:
                    best_corr = abs_corrcoef
                    best_offset = offset
                offset -= n_days

            sql = 'insert into mars_tianchi_series_correlation values(\'%s\', \'%s\', \'%s\', \'%s\', %d, %d, %f)' % (artist_id, name, strPlaysSeriesBegin, strPlaysSeriesEnd, n_days, best_offset, best_corr)
            cursor.execute(sql)

        playsSeriesBegin += timedelta(days=n_days)

    db.commit()
    db.close()

def main():
    correlation('plays')

if __name__ == '__main__':
    main()
