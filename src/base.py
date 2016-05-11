import numpy as np
from sklearn.ensemble import RandomForestRegressor

TIME_FORMAT='%Y%m%d'
N_SERIES_DAYS=15
MIN_CORRELATION=0.0
IS_CATEGORY=np.ones(10)
BASE_MODEL=RandomForestRegressor
