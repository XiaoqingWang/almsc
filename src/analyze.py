import datetime
import numpy as np
from matplotlib import pyplot as plt 
from matplotlib.dates import date2num
from base import init, _n_artists, _n_days
from feature_extract import feature

def showPredict(i_artists=1):
    assert(i_artists in range(0, _n_artists+1))
    sample, X, y = feature()

    model = init().fit(X, y)

    sample, X, y = feature(isTrain=False)
    y_predict = model.predict(X)

    first_day = datetime.datetime.strptime(sample[0,1], '%Y%m%d')
    x_data = np.arange(_n_days) + date2num(first_day)
    if i_artists > 0:
        y_data_1 = y[(i_artists-1) * _n_days:i_artists * _n_days]
        y_data_2 = y_predict[(i_artists-1) * _n_days:i_artists * _n_days]
    else:
        y_data_1 = np.mean(y.reshape(_n_artists, _n_days), axis=0)
        y_data_2 = np.mean(y_predict.reshape(_n_artists, _n_days), axis=0)

    plt.plot_date(x_data, y_data_1, 'g', label='real')
    plt.plot_date(x_data, y_data_2, 'r', label='predict')
    plt.show()

def main():
    showPredict(i_artists=0)

if __name__ == '__main__':
    main()
