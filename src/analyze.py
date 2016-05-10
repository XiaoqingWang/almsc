import datetime
import numpy as np
from matplotlib import pyplot as plt 
from matplotlib.dates import date2num
from base import n_artists, n_days
from model import init
from extract import border, feature, artist, day, artist_day
from database import connect


def showPredict(i_artists=0):
    assert(i_artists in range(0, n_artists+1))
    sample, X, y, weight = feature()

    model = init().fit(X, y, **{'model__sample_weight':weight})

    sample, X, y, weight = feature(isTrain=False)
    y_predict = model.predict(X)

    first_day = datetime.datetime.strptime(sample[0,1], '%Y%m%d')
    x_data = np.arange(n_days) + date2num(first_day)
    if i_artists > 0:
        y_data_1 = y[(i_artists-1) * n_days:i_artists * n_days]
        y_data_2 = y_predict[(i_artists-1) * n_days:i_artists * n_days]
        plt.title('Plays of Artist[%s] per Day' % sample[(i_artists-1) * n_days,0])
        print '[artist]', sample[(i_artists-1) * n_days,0]
    else:
        y_data_1 = np.mean(y.reshape(n_artists, n_days), axis=0)
        y_data_2 = np.mean(y_predict.reshape(n_artists, n_days), axis=0)
        plt.title('Plays of Artists per Day')

    plt.plot_date(x_data, y_data_1, fmt='g', label='real')
    plt.plot_date(x_data, y_data_2, fmt='r', label='predict')
    plt.xlabel('day')
    plt.ylabel('plays')
    plt.show()
    
def showArtist(begin=None, end=None, actionType=1):
    assert(actionType in range(1, 4))
    artists, n_actions = artist(begin=begin, end=end, actionType=actionType)
    plt.boxplot([n_actions], labels=['n_actions'])
    plt.title('Plays of Artists')
    plt.show()

def showDay(begin=None, end=None, actionType=1):
    assert(actionType in range(1, 4))
    days, n_actions = day(begin=begin, end=end, actionType=actionType)
    plt.boxplot([n_actions], labels=['n_actions'])
    plt.title('Plays of Days')
    plt.show()

def showArtistDay(begin=None, end=None, actionType=1, i_artists=0):
    assert(actionType in range(1, 4))
    assert(i_artists in range(0, n_artists+1))
    artists, days, n_actions = artist_day(begin=begin, end=end, actionType=actionType)
    if i_artists > 0:
        plt.boxplot([n_actions[(i_artists-1)*n_days:i_artists*n_days]], labels=[artists[(i_artists-1)*n_days]])
    else:
        plt.boxplot(n_actions.reshape(n_artists, n_days).T, labels=artists.reshape(n_artists, n_days)[:,0])
    plt.title('Plays of Artists and Days')
    plt.show()

def abnormalArtist(begin=None, end=None, actionType=1):
    assert(actionType in range(1, 4))
    artists, n_actions = artist(begin=begin, end=end, actionType=actionType)
    mean = np.mean(n_actions)
    std = np.std(n_actions)
    abs_z_score = np.hstack((artists.reshape(-1, 1), (np.abs(n_actions - mean) / std).reshape(-1, 1)))
    return filter(lambda x:float(x[1]) > 3, abs_z_score)

def abnormalDay(begin=None, end=None, actionType=1):
    assert(actionType in range(1, 4))
    days, n_actions = day(begin=begin, end=end, actionType=actionType)
    mean = np.mean(n_actions)
    std = np.std(n_actions)
    abs_z_score = np.hstack((days.reshape(-1, 1), (np.abs(n_actions - mean) / std).reshape(-1, 1)))
    return filter(lambda x:float(x[1]) > 3, abs_z_score)

def abnormalArtistDay(begin=None, end=None, actionType=1, i_artists=0):
    assert(actionType in range(1, 4))
    artists, days, n_actions = artist_day(begin=begin, end=end, actionType=actionType)
    if i_artists > 0:
        artists = artists.reshape(n_artists, n_days)[[i_artists]]
        days = days.reshape(n_artists, n_days)[[i_artists]]
        n_actions = n_actions.reshape(n_artists, n_days)[[i_artists]]
    else:
        artists = artists.reshape(n_artists, n_days)
        days = days.reshape(n_artists, n_days)
        n_actions = n_actions.reshape(n_artists, n_days)
    mean = np.mean(n_actions, axis=1).reshape(-1,1)
    std = np.std(n_actions, axis=1).reshape(-1,1)
    abs_z_score = np.hstack((artists, days, (np.abs(n_actions - mean) / std)))
    return map(lambda x:filter(lambda y:float(y[2]) > 3, np.vstack((x[:n_days], x[n_days:2*n_days], x[2*n_days:])).T), abs_z_score)

def main():
    beginTrain = border(isTrain=True, isBegin=True)
    endTrain = border(isTrain=True, isBegin=False)
    beginTest = border(isTrain=False, isBegin=True)
    endTest = border(isTrain=False, isBegin=False)
    print '[train]', beginTrain, endTrain
    print '[test]', beginTest, endTest
    showPredict(i_artists=0)
#    showArtist(begin=beginTrain, end=endTrain)
#    showDay(begin=beginTrain, end=endTrain)
#    showArtistDay(begin=beginTrain, end=endTrain, i_artists=0)
#    print abnormalArtist(begin=beginTrain, end=endTrain)
#    print abnormalDay(begin=beginTrain, end=endTrain)
#    artist_day_list = abnormalArtistDay(begin=beginTrain, end=endTrain, i_artists=0)
#    for day_list in artist_day_list:
#        for detail in day_list:
#            print detail

if __name__ == '__main__':
    main()
