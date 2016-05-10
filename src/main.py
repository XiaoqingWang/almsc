#!/usr/bin/env python

import numpy as np
from model import init, score
from extract import feature

def main():
    sample, X, y, weight  = feature()
    print '[shape]', X.shape

    model = init().fit(X, y, **{'model__sample_weight':weight})
    print '[coef]', model.get_params()['model'].feature_importances_

    sample, X, y, weight = feature(isTrain=False)
    
    real_score, ideal_score = score(model, X, y)
    print '[score]', real_score, ideal_score, real_score / ideal_score

if __name__ == '__main__':
    main()
