import numpy as np
from matplotlib import pyplot as plt
from base import init, _n_artists, _n_days
from feature_extract import feature

def showPredict(i_artists=1):
    assert(i_artists in range(1, _n_artists+1))
    sample, X, y = feature()

    model = init().fit(X, y)

    sample, X, y = feature(isTrain=False)
    y_predict = model.predict(X)

    x_data = np.arange(1, _n_days+1)
    y_data_1 = y[(i_artists-1) * _n_days:i_artists * _n_days]
    y_data_2 = y_predict[(i_artists-1) * _n_days:i_artists * _n_days]

    plt.plot(x_data, y_data_1, 'g')
    plt.plot(x_data, y_data_2, 'r')
    plt.show()

def main():
    showPredict(i_artists=1)

if __name__ == '__main__':
    main()
