#!/usr/bin/env python
from datetime import datetime
from argparse import ArgumentParser
import numpy as np
from matplotlib import pyplot as plt
from matplotlib.dates import date2num
from extract import get_n_artists, get_n_days
from database import connect
from extract import getPredict

def _checkin(recordId):
    db = connect()
    cursor = db.cursor()
    sql = 'delete from mars_tianchi_artist_plays_predict where record_id = \'%s\'' % recordId
    cursor.execute(sql)

    result = np.hstack((np.repeat(recordId, get_n_artists() * get_n_days(isX=False, isTrain=False)).reshape(-1,1), np.loadtxt('../data/mars_tianchi_artist_plays_predict.csv', dtype='str', delimiter=',')))
    for line in result:
        sql = 'insert into mars_tianchi_artist_plays_predict values(\'%s\', \'%s\', \'%s\', %s)' % (line[0], line[1], line[3], line[2]) 
        cursor.execute(sql)

    db.commit()
    db.close()

def _checkout(recordId):
    result = getPredict(recordId)
    np.savetxt('../data/mars_tianchi_artist_plays_predict.csv', result, fmt='%s', delimiter=',')

def _analyze(recordIdList):
    n_artists = get_n_artists()
    n_days = get_n_days(isX=False, isTrain=False)

    resultDict = dict()
    for recordId in recordIdList:
        resultDict[recordId] = getPredict(recordId)

    fig, axes = plt.subplots(ncols=n_artists)
    for i in range(n_artists):
        for recordId in recordIdList:
            result = resultDict[recordId]
            dsList = result[:,2]
            firstDay = datetime.strptime(dsList[0], '%Y%m%d')
            artist_id = result[0,1]
            xData = np.arange(n_days) + date2num(firstDay)
            yData = result[i*n_days:(i+1)*n_days,3]
            subplot = axes[i]
            subplot.plot_date(xData, yData, label=artist_id)
            subplot.xlabel('day')
            subplot.ylabel('plays')
            subplot.legend(loc='best', shadow=True, fontsize='x-large')
    plt.show()

def main():
    parser = ArgumentParser(description='Prediction Recording Application')
    parser.add_argument('action', action='store', choices=('checkin', 'checkout', 'analyze'), help='Action')
    parser.add_argument('-r', action='append', dest='recordId', default=list(),  help='ID Of Record')
    argsDict = parser.parse_args()

    if argsDict.action in ('checkin', 'checkout'):
        assert(len(argsDict.recordId) == 1)
        if argsDict.action == 'checkin':
            _checkin(argsDict.recordId[0])
        else:
            _checkout(argsDict.recordId[0])
    else:
        assert(len(argsDict.recordId) >= 1)
        _analyze(argsDict.recordId)


if __name__ == '__main__':
    main()
