import numpy as np
from sklearn.preprocessing import Imputer
from sklearn.preprocessing import OneHotEncoder
from sklearn.preprocessing import StandardScaler
from sklearn.feature_selection import RFE
from sklearn.feature_selection import SelectFromModel
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.ensemble import RandomForestRegressor
from sklearn.svm import SVR
from sklearn.pipeline import Pipeline
from sklearn.grid_search import GridSearchCV
from extract import encoder_list

_n_artists = 50
_n_days = 61

def score(model, X, y):
    y = y.reshape(_n_artists, _n_days)
    y_impute = Imputer(missing_values=0).fit_transform(y.T).T
    y_predict = model.predict(X).reshape(_n_artists, _n_days)
    std = np.sqrt(np.mean(np.power((y_predict - y) / y_impute, 2), axis=1))
    print '[std]', std
    weight = np.sqrt(np.sum(y, axis=1))
    print '[weight]', weight
    real_score =  np.dot(1-std, weight)
    ideal_score = np.sum(weight)
    print '[random_score]', np.dot(np.random.uniform(0, 1, size=_n_artists), weight)
    print '[excellent_score]', np.dot(1-np.ones(_n_artists)/10, weight)
    return real_score, ideal_score

def init():
    step1 = ('OneHotEncoder', OneHotEncoder(sparse=False, handle_unknown='ignore',categorical_features = encoder_list()))
    step2 = ('StandardScaler', StandardScaler())
#    step3 = ('RFE', RFE(estimator=GradientBoostingRegressor(), n_features_to_select=10))
#    step3 = ('SelectFromModel', SelectFromModel(GradientBoostingRegressor()))
#    step4 = ('model', GradientBoostingRegressor())
    step4 = ('model', GradientBoostingRegressor())
    pipeline = Pipeline(steps=[step1, step2, step4])
#    grid_search = GridSearchCV(pipeline, param_grid={'RFE__n_features_to_select':[20]})
    return pipeline
