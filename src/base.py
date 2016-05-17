import numpy as np
from sklearn.ensemble import RandomForestRegressor
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.linear_model import LinearRegression
from sklearn.svm import LinearSVR
ISOFFLINE = True
HOST = 'almsc'
USER = 'root'
PASSWORD = 'Almsc@2016'
if ISOFFLINE:
    print '[-------------------------O F F L I N E-------------------------]'
    DATABASE = 'almsc_offline'
else:
    print '[--------------------------O N L I N E--------------------------]'
    DATABASE = 'almsc_online'
TIME_FORMAT='%Y%m%d'
N_SERIES_DAYS=15
#BASE_MODEL=RandomForestRegressor()
BASE_MODEL=LinearSVR()
if isinstance(BASE_MODEL, LinearSVR):
    GRIDPARAMS = {
    'model__C':np.arange(1, 20).astype('float64') / 20,
    }
elif isinstance(BASE_MODEL, RandomForestRegressor):
    GRIDPARAMS = {
    'model__n_estimators':np.arange(1, 20),
    'model__min_samples_split':np.arange(2, 51), 
    'model__min_samples_leaf':np.arange(1, 51),
    }
else:
    raise Exception('unkown model[%s]' % BASE_MODEL)
RF_MODEL=LinearSVR(C=0.05)
N_SELECTED_FEATURES=0
FEATURES = {
#artist
'r_artist_code':True,
'r_n_songs':False,
'r_gender':True,
'r_n_languages':False,
'r_mode_language':True,
'r_avg_plays':False,
'r_std_plays':False,
'r_cov_plays':False,
'r_plays':False,
'r_avg_plays_last_3_days':False,
'r_avg_plays_last_5_days':False,
'r_avg_plays_last_7_days':False,
'r_q2_plays_div_q1_plays':False,
'r_q3_plays_div_q2_plays':False,
'r_q4_plays_div_q3_plays':False,
'r_sum_plays':False,
'r_sum_downloads':False,
'r_sum_collects':False,
'r_sum_downloads_div_sum_plays':False,
'r_sum_collects_div_sum_plays':False,
'r_q3_q2_q1_acceleration':False,
'r_q4_q3_q2_acceleration':False,
#day
'r_month':True,
'r_day':True,
'r_season':True,
'r_week':True,
'r_weekday':True,
'r_is_holiday':False,
'r_n_holidays':False,
'r_i_holidays':True,
'r_is_good_voice':False,
'r_is_music_festival':False,
'r_diff_days':True,
#artist & day
'r_avg_plays_weekday':False,
#series
's_plays':False,
's_avg_plays_last_3_days':False,
's_avg_plays_last_5_days':False,
's_avg_plays_last_7_days':False,
's_downloads':False,
's_avg_downloads_last_3_days':False,
's_avg_downloads_last_5_days':False,
's_avg_downloads_last_7_days':False,
's_collects':False,
's_avg_collects_last_3_days':False,
's_avg_collects_last_5_days':False,
's_avg_collects_last_7_days':False,
's_diff_plays':False,
's_diff_downloads':False,
's_diff_collects':False,
's_plays_div_plays_prev_1_days':False,
's_plays_div_plays_prev_2_days':False,
's_plays_div_plays_prev_4_days':False,
's_plays_div_plays_prev_6_days':False,
's_plays_div_downloads':False,
's_plays_div_downloads_last_3_days':False,
's_plays_div_downloads_last_5_days':False,
's_plays_div_downloads_last_7_days':False,
's_plays_div_collects':False,
's_plays_div_collects_last_3_days':False,
's_plays_div_collects_last_5_days':False,
's_plays_div_collects_last_7_days':False,
's_play_users':False,
's_avg_play_users_last_3_days':False,
's_avg_play_users_last_5_days':False,
's_avg_play_users_last_7_days':False,
's_users':False,
's_new_users':False,
's_new_users_div_users':False,
's_diff_users':False,
's_new_plays':False,
's_new_plays_div_plays':False,
}
