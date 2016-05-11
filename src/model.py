import numpy as np
from sklearn.preprocessing import StandardScaler
from sklearn.preprocessing import Imputer
from sklearn.preprocessing import OneHotEncoder
from sklearn.pipeline import Pipeline
from sklearn.externals.joblib import dump, load
from base import BASE_MODEL
from extract import getArtistIdList, get_n_artists, get_n_series, getFeatures, get_n_days

def score(model, X, y):
    y = y.reshape(n_artists, n_days)
    y_predict = model.predict(X).reshape(n_artists, n_days)
    std = np.sqrt(np.mean(np.power((y_predict - y) / y_impute, 2), axis=1))
    print '[std]', std
    weight = np.sqrt(np.sum(y, axis=1))
    print '[weight]', weight
    real_score =  np.dot(1-std, weight)
    ideal_score = np.sum(weight)
    print '[random_score]', np.dot(np.random.uniform(0, 1, size=n_artists), weight)
    print '[excellent_score]', np.dot(1-np.ones(n_artists)/10, weight)
    return real_score, ideal_score

def init():
    step1 = ('OneHotEncoder', OneHotEncoder(sparse=False, handle_unknown='ignore'))
    step2 = ('StandardScaler', StandardScaler())
    step3 = ('model', BASE_MODEL())
    pipeline = Pipeline(steps=[step1, step2, step3])
    artistIdList = getArtistIdList()
    n_artists = get_n_artists()
    n_series = get_n_series()
    for i in range(n_artists):
        print '[init]', artistIdList[i], i
        for j in range(n_series):
#            print '[init]', artistIdList[i], i, j
            dump(pipeline, 'model/%s_%d_%d' % (artistIdList[i], i, j), compress=3)

def fit():
    artistIdList = getArtistIdList()
    n_artists = get_n_artists()
    n_series = get_n_series()
    for i in range(n_artists):
        print '[fit]', artistIdList[i], i
        for j in range(n_series):
            pipeline = load('model/%s_%d_%d' % (artistIdList[i], i, j))
            X, y, categoryIndexList = getFeatures(artistIdList[i], j ,isTrain=True)
            pipeline.set_params(OneHotEncoder__categorical_features=categoryIndexList)
            pipeline.fit(X, y)
#            print '[fit]', artistIdList[i], i, j, pipeline.get_params()['model'].feature_importances_
            dump(pipeline, 'model/%s_%d_%d' % (artistIdList[i], i, j), compress=3)

def predict():
    real_score = 0
    ideal_score = 0
    artistIdList = getArtistIdList()
    n_artists = get_n_artists()
    n_series = get_n_series()
    n_y_days = get_n_days(isX=True, isTrain=False)
    for i in range(n_artists):
        sum_plays = 0
        sum_var = 0
        for j in range(n_series):
#            print '[predict]', artistIdList[i], i, j
            pipeline = load('model/%s_%d_%d' % (artistIdList[i], i, j))
            X, y, categoryIndexList = getFeatures(artistIdList[i], j ,isTrain=False)
            y_impute = Imputer(missing_values=0).fit_transform(y.reshape(-1,1)).flatten()
            y_predict = pipeline.predict(X)
#            dump(y_predict, 'predict/%s_%d_%d' % (artistIdList[i], i, j), compress=3)
            sum_plays += np.sum(y)
            sum_var += np.sum(np.power((y_predict - y) / y_impute, 2))
        weight = np.sqrt(sum_plays)
        std = np.sqrt(sum_var/n_y_days)
        real_score += (1-std) * weight
        ideal_score += weight
        print '[predict]', artistIdList[i], i, weight, 1-std
    print '[score]', real_score, ideal_score, real_score / ideal_score
