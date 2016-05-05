#!/usr/bin/env python

import numpy as np
from sklearn.preprocessing import OneHotEncoder
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.pipeline import Pipeline
from feature_extract import feature
from base import score

_n_days = 61
_n_artist = 50

def main():
    sample, y, X = feature()

    step1 = ('OneHotEncoder', OneHotEncoder(sparse=False, handle_unknown='ignore'))
    step2 = ('model', GradientBoostingRegressor())
    pipline = Pipeline(steps=[step1, step2]).fit(X, y)

    sample, y, X = feature(isTrain=False)
    #print sample, X.shape, y.shape

    print score(pipline, _n_artist, _n_days, X, y)

if __name__ == '__main__':
    main()
