import numpy as np
from sklearn.preprocessing import StandardScaler
from sklearn.preprocessing import Imputer
from sklearn.preprocessing import OneHotEncoder
from sklearn.feature_selection import RFE
from sklearn.pipeline import Pipeline
from sklearn.grid_search import GridSearchCV
from sklearn.externals.joblib import dump, load
from base import BASE_MODEL, FEATURES, RF_MODEL, N_SELECTED_FEATURES, GRIDPARAMS
from extract import getArtistIdList, get_n_artists, get_n_series, getFeatures, get_n_days

def _getEncoderList(boolList):
    encoderList = range(len(boolList))
    encoderList = filter(lambda x:boolList[x], encoderList)
    return encoderList

def _getEncodedFeatureNameList(featureNameList, booList, active_features, feature_indices):
    encodedFeatureNameList = []
    index1 = 0
    index2 = 0
    for i in range(len(featureNameList)):
        if booList[i]:
            offset = index1
            n_values = sum(map(lambda x:1 if feature_indices[index2] < x and x < feature_indices[index2+1] else 0, active_features))
            for j in range(offset, offset+n_values):
                encodedFeatureNameList.append('%s_%d' % (featureNameList[i], j - offset))
                index1 += 1
            index2 += 1
        else:
            encodedFeatureNameList.append(featureNameList[i])
            index1 += 1
    return encodedFeatureNameList

def _getSelectedFeatureNameList(featureNameList, support):
    selectedFeatureNameList = []
    for i in range(len(featureNameList)):
        if support[i]:
            selectedFeatureNameList.append(featureNameList[i])
    return selectedFeatureNameList

def init():
    step1 = ('OneHotEncoder', OneHotEncoder(sparse=False, handle_unknown='ignore', categorical_features=_getEncoderList(FEATURES.values())))
    step2 = ('StandardScaler', StandardScaler())
    step3 = ('RFE', RFE(estimator=RF_MODEL, n_features_to_select=N_SELECTED_FEATURES))
    step4 = ('model', BASE_MODEL)
    if N_SELECTED_FEATURES > 0:
        pipeline = Pipeline(steps=[step1, step2, step3, step4])
    else:
        pipeline = Pipeline(steps=[step1, step2, step4])
    dump(pipeline, 'dump/model', compress=3)

def fit():
    artistIdList, dsList, X, y = getFeatures(isTrain=True)
    pipeline = load('dump/model')
    search = GridSearchCV(pipeline, GRIDPARAMS)
    search.fit(X, y)
    pipeline = search.best_estimator_
    coder = pipeline.named_steps['OneHotEncoder']
    encodedFeatureNameList = _getEncodedFeatureNameList(FEATURES.keys(), FEATURES.values(), coder.active_features_, coder.feature_indices_)
    if N_SELECTED_FEATURES > 0:
        selectedFeatureNameList = _getSelectedFeatureNameList(encodedFeatureNameList, pipeline.named_steps['RFE'].support_)
    else:
        selectedFeatureNameList = encodedFeatureNameList
    model = pipeline.named_steps['model']
    coefList = None
    if hasattr(model, 'feature_importances_'):
        coefList = model.feature_importances_
    elif hasattr(model, 'coef_'):
        coefList = model.coef_
    if coefList is not None:
        indexList = sorted(range(len(selectedFeatureNameList)), key=lambda x:coefList[x], reverse=True)
        for index in indexList:
            print '[fit] NAME[%60s], COEF[%12.4f]' % (selectedFeatureNameList[index], coefList[index])
    print '[PARAMS]', pipeline.named_steps['model'].get_params()
    dump(pipeline, 'dump/model', compress=3)

def predict(isOffline=True):
    artistIdList, dsList, X, y = getFeatures(isTrain=True)
    pipeline = load('dump/model')
    n_artists = get_n_artists()
    n_days = get_n_days(isX=False, isTrain=False)
    yPredictRaw = pipeline.predict(X)
    yPredictRaw[yPredictRaw < 0] = 0
    yPredictRaw = np.round(yPredictRaw).astype('int64')
    if isOffline:
        yPredict = yPredictRaw.reshape(n_artists, n_days)
        yReal = y.reshape(n_artists, n_days)
        yImpute = Imputer(missing_values=0).fit_transform(yReal.T).T
        std = np.sqrt(np.mean(np.power((yPredict - yReal) / yImpute, 2), axis=1))
        precision = 1 - std
        weight = np.sqrt(np.sum(yReal, axis=1))
        realScore =  np.round(np.dot(precision, weight)).astype('int64')
        idealScore = np.round(np.sum(weight)).astype('int64')
        percenctScore = realScore * 1.0 / idealScore
        indexList = range(n_artists)
        indexList = sorted(indexList, key=lambda x:precision[x], reverse=True)
        for i in range(n_artists):
            print '[predict] [%2d] ARTIST_ID[%32s], WEIGHT[%12.4f], PRECISION[%12.4f]' % (indexList[i]+1, artistIdList[indexList[i]*n_days], weight[indexList[i]], precision[indexList[i]])
        print '[CONCLUTION]', realScore, idealScore, percenctScore
        return artistIdList, dsList, yReal, yPredict
    else:
        result = np.hstack((artistIdList.reshape(-1,1), yPredictRaw.reshape(-1,1), dsList.reshape(-1,1)))
        np.savetxt('../data/mars_tianchi_artist_plays_predict.csv', result, fmt='%s', delimiter=',')
