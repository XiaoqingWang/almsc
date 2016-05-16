#!/usr/bin/env python

import numpy as np
from base import ISOFFLINE
from model import init, fit, predict

def main():
    init()
    fit()
    predict(isOffline=ISOFFLINE)

if __name__ == '__main__':
    main()
