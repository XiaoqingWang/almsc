import numpy as np
from sklearn.preprocessing import Imputer

def score(model, n_artists, n_days, X, y):
    y = y.reshape(n_artists, n_days)
    y_impute = Imputer(missing_values=0).fit_transform(y.T).T
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
