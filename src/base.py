import numpy as np
from sklearn.preprocessing import Imputer

def score(model, n_artists, n_days, X, y):
    y = y.reshape(n_artists, n_days)
    y_impute = Imputer(missing_values=0).fit_transform(y.T).T
    y_predict = model.predict(X).reshape(n_artists, n_days)
    std = np.sqrt(np.mean(np.power((y_predict - y) / y_impute, 2), axis=1))
    weight = np.sqrt(np.sum(y, axis=1))
    score =  np.dot(1-std, weight)
    return score
