#!/usr/bin/env python

import numpy as np
from base import init, score
from feature_extract import feature

def main():
    sample, X, y = feature()

    model = init().fit(X, y)
    print '[coef]', model.get_params()['model'].feature_importances_

    sample, X, y = feature(isTrain=False)
    
    real_score, ideal_score = score(model, X, y)
    print '[score]', real_score, ideal_score

if __name__ == '__main__':
    main()
