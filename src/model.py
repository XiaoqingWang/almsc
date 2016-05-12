import numpy as np
from sklearn.preprocessing import StandardScaler
from sklearn.preprocessing import Imputer
from sklearn.preprocessing import OneHotEncoder
from sklearn.pipeline import Pipeline
from sklearn.externals.joblib import dump, load
from base import BASE_MODEL, FEATURES
from extract import getArtistIdList, get_n_artists, get_n_series, getFeatures, get_n_days

def _getEncoderList(isCategoryList):
    encoderList = range(len(isCategoryList))
    encoderList = filter(lambda x:isCategoryList[x], encoderList)
    return encoderList

def init():
    step1 = ('OneHotEncoder', OneHotEncoder(sparse=False, handle_unknown='ignore', categorical_features=_getEncoderList(FEATURES.values())))
    step2 = ('StandardScaler', StandardScaler())
    step3 = ('model', BASE_MODEL())
    pipeline = Pipeline(steps=[step1, step2, step3])
    dump(pipeline, 'dump/model', compress=3)

def fit():
    artistIdList, dsList, X, y = getFeatures(isTrain=True)
    print '[X]', X[0]
    pipeline = load('dump/model')
    pipeline.fit(X, y)
    print '[fit]', pipeline.get_params()['model'].feature_importances_
    dump(pipeline, 'dump/model', compress=3)

def predict():
    artistIdList, dsList, X, y = getFeatures(isTrain=False)
    pipeline = load('dump/model')
    n_artists = get_n_artists()
    n_days = get_n_days(isX=False, isTrain=False)
    y = y.reshape(n_artists, n_days)
    y_impute = Imputer(missing_values=0).fit_transform(y.T).T
    y_predict = pipeline.predict(X).reshape(n_artists, n_days)
    std = np.sqrt(np.mean(np.power((y_predict - y) / y_impute, 2), axis=1))
    print '[std]', std
    weight = np.sqrt(np.sum(y, axis=1))
    print '[weight]', weight
    real_score =  np.dot(1-std, weight)
    ideal_score = np.sum(weight)
    print '[random_score]', np.dot(np.random.uniform(0, 1, size=n_artists), weight)
    print '[excellent_score]', np.dot(1-np.ones(n_artists)/10, weight)
    print '[real_score]', real_score
    print '[ideal_score]', ideal_score, real_score / ideal_score
