#!/usr/bin/env python
from datetime import datetime
from argparse import ArgumentParser
import numpy as np
from matplotlib import pyplot as plt 
from matplotlib.dates import date2num, DateFormatter 
from matplotlib.backends.backend_pdf import PdfPages
from base import ISOFFLINE
from extract import get_n_artists, get_n_days, getPlays
from model import predict

def showPredict():
    n_artists = get_n_artists()
    n_days = get_n_days(isX=False, isTrain=False)
    artistIdList, dsList, yReal, yPredict = predict(isOffline=ISOFFLINE)
    yTrain = getPlays(isTrain=True)
    yTrain = yTrain.reshape(n_artists, n_days)

    firstDay = datetime.strptime(dsList[0], '%Y%m%d')
    xData = np.arange(n_days) + date2num(firstDay)
    pdf = PdfPages('../report/analyze.pdf')
    for i in range(n_artists):
        fig = plt.figure()
        ax = plt.axes()
        ax.xaxis.set_major_formatter(DateFormatter('%m%d'))
        yRealData = yReal[i]
        yPredictData = yPredict[i]
        yTrainData = yTrain[i]
        artist_id = artistIdList[i*n_days]
        plt.plot_date(xData, yRealData, fmt='-^g', label='real')
        plt.plot_date(xData, yPredictData, fmt='-vr', label='predict')
        plt.plot_date(xData, yTrainData, fmt='-ob', label='train')
        plt.legend(loc='best', shadow=True)
        plt.xlabel('day')
        plt.ylabel('plays')
        plt.title(artist_id)
        pdf.savefig(fig)
        plt.close()
    pdf.close()

def main():
    showPredict()

if __name__ == '__main__':
    main()
