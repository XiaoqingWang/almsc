#!/usr/bin/env python

import numpy as np
from sklearn.preprocessing import OneHotEncoder
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.pipeline import Pipeline
from feature_extract import feature
from base import score
from feature_union_ext import FeatureUnionExt

_n_days = 61
_n_artist = 50

def main():
    sample, y, X = feature()

    step1_1 = ('OneHotEncoder', OneHotEncoder(sparse=False, handle_unknown='ignore'))
    step1_2 = ('StandardScaler', StandardScaler())
    step1 = ('FeatureUnionExt', FeatureUnionExt(transformer_list=[step1_1, step1_2], idx_list=[range(8), range(8, 13)]))
    step2 = ('model', GradientBoostingRegressor())

    pipline = Pipeline(steps=[step1, step2]).fit(X, y)
    print '[coef]', step2[1].feature_importances_

    sample, y, X = feature(isTrain=False)
    
    real_score, ideal_score = score(pipline, _n_artist, _n_days, X, y)
    print '[score]', real_score, ideal_score

if __name__ == '__main__':
    main()
