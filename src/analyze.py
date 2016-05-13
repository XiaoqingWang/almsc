from datetime import datetime
import numpy as np
from matplotlib import pyplot as plt 
from matplotlib.dates import date2num
from model import predict
from extract import get_n_artists
from model import predict

def showPredict(i_artists=0):
    n_artists = get_n_artists()
    assert(i_artists in range(n_artists+1))
    n_days = get_n_days(isX=False, isTrain=False)
    artistIdList, dsList, yReal, yPredict = model.predict(X)

    firstDay = datetime.strptime(dsList[0], '%Y%m%d')
    xData = np.arange(n_days) + date2num(firstDay)
    if i_artists > 0:
        yRealData = yReal[i_artists-1]
        yPredictData = yPredict[i_artists-1]
        plt.title('Plays of Artist[%s] per Day' % artistIdList[(i_artists-1) * n_days])
    else:
        yRealData = np.mean(yReal), axis=0)
        yPredictData = np.mean(yPredict,  axis=0)
        plt.title('Plays of Artists per Day')

    plt.plot_date(xData, yRealData, fmt='g', label='real')
    plt.plot_date(xData, yPredictData, fmt='r', label='predict')
    plt.xlabel('day')
    plt.ylabel('plays')
    plt.show()

def main():
    showPredict(i_artists=0)

if __name__ == '__main__':
    main()
