from datetime import datetime
from argparse import ArgumentParser
import numpy as np
from matplotlib import pyplot as plt 
from matplotlib.dates import date2num
from base import ISOFFLINE
from extract import get_n_artists, get_n_days, getPlays
from model import predict

def showPredict(i_artists=0):
    n_artists = get_n_artists()
    assert(i_artists in range(n_artists+1))
    n_days = get_n_days(isX=False, isTrain=False)
    artistIdList, dsList, yReal, yPredict = predict(isOffline=ISOFFLINE)
    yTrain = getPlays(isTrain=True)
    yTrain = yTrain.reshape(n_artists, n_days)

    firstDay = datetime.strptime(dsList[0], '%Y%m%d')
    xData = np.arange(n_days) + date2num(firstDay)
    if i_artists > 0:
        yRealData = yReal[i_artists-1]
        yPredictData = yPredict[i_artists-1]
        yTrainData = yTrain[i_artists-1]
        plt.title('Plays of Artist[%s] per Day' % artistIdList[(i_artists-1) * n_days])
    else:
        yRealData = np.mean(yReal, axis=0)
        yPredictData = np.mean(yPredict,  axis=0)
        yTrainData = np.mean(yTrain,  axis=0)
        plt.title('Plays of Artists per Day')

    plt.plot_date(xData, yRealData, fmt='-^g', label='real')
    plt.plot_date(xData, yPredictData, fmt='-vr', label='predict')
    plt.plot_date(xData, yTrainData, fmt='-ob', label='train')
    plt.xlabel('day')
    plt.ylabel('plays')
    plt.show()

def main():
    parser = argparse.ArgumentParser(description='analyze application for real plays, predicted plays and plays of train period') 
    parser.add_argument('-i', action='store', dest='i_artists', type=int, help='Number of artist, 0 for all')
    argsDict = parser.parse_args()
    showPredict(i_artists=argsDict.i_artists)

if __name__ == '__main__':
    main()
