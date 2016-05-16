set @begin_X_train:=(select min(ds) from mars_tianchi_samples where is_X = 1 and is_train = 1);
set @end_X_train:=(select max(ds) from mars_tianchi_samples where is_X = 1 and is_train = 1);
set @begin_y_train:=(select min(ds) from mars_tianchi_samples where is_X = 0 and is_train = 1);
set @end_y_train:=(select max(ds) from mars_tianchi_samples where is_X = 0 and is_train = 1);
set @begin_X_test:=(select min(ds) from mars_tianchi_samples where is_X = 1 and is_train = 0);
set @end_X_test:=(select max(ds) from mars_tianchi_samples where is_X = 1 and is_train = 0);
set @begin_y_test:=(select min(ds) from mars_tianchi_samples where is_X = 0 and is_train = 0);
set @end_y_test:=(select max(ds) from mars_tianchi_samples where is_X = 0 and is_train = 0);
-----------------------------------------------
drop table if exists mars_tianchi_features;
create table mars_tianchi_features
(
artist_id char(32),
ds char(8),
primary key(artist_id, ds)
);
insert into mars_tianchi_features(artist_id, ds) select artist_id, ds from mars_tianchi_samples where is_X = 0;
--select distinct(artist_id) from mars_tianchi_features;
-----------------------------------------------
--time
--drop column
alter table mars_tianchi_features drop column r_month;
alter table mars_tianchi_features drop column r_day;
alter table mars_tianchi_features drop column r_season;
alter table mars_tianchi_features drop column r_week;
alter table mars_tianchi_features drop column r_weekday;
alter table mars_tianchi_features drop column r_is_holiday;
alter table mars_tianchi_features drop column r_n_holidays;
alter table mars_tianchi_features drop column r_i_holidays; 
alter table mars_tianchi_features drop column r_is_good_voice;
alter table mars_tianchi_features drop column r_is_music_festival;
alter table mars_tianchi_features drop column r_diff_days;
--add column
alter table mars_tianchi_features add (r_month int);
alter table mars_tianchi_features add (r_day int);
alter table mars_tianchi_features add (r_season int);
alter table mars_tianchi_features add (r_week int);
alter table mars_tianchi_features add (r_weekday int);
alter table mars_tianchi_features add (r_is_holiday int);
alter table mars_tianchi_features add (r_n_holidays int);
alter table mars_tianchi_features add (r_i_holidays int);
alter table mars_tianchi_features add (r_is_good_voice int);
alter table mars_tianchi_features add (r_is_music_festival int);
alter table mars_tianchi_features add (r_diff_days int);
--all
update mars_tianchi_features
left join mars_tianchi_ds on mars_tianchi_features.ds = mars_tianchi_ds.ds set
mars_tianchi_features.r_month = mars_tianchi_ds.month,
mars_tianchi_features.r_day = mars_tianchi_ds.day,
mars_tianchi_features.r_season = mars_tianchi_ds.season,
mars_tianchi_features.r_week = mars_tianchi_ds.week,
mars_tianchi_features.r_weekday = mars_tianchi_ds.weekday,
mars_tianchi_features.r_is_holiday = mars_tianchi_ds.is_holiday,
mars_tianchi_features.r_n_holidays = mars_tianchi_ds.n_holidays,
mars_tianchi_features.r_i_holidays = mars_tianchi_ds.i_holidays,
mars_tianchi_features.r_is_good_voice = mars_tianchi_ds.is_good_voice,
mars_tianchi_features.r_is_music_festival = mars_tianchi_ds.is_music_festival;
--train
update mars_tianchi_features set r_diff_days = datediff(ds, @begin_y_train) where ds between @begin_y_train and @end_y_train;
--test
update mars_tianchi_features set r_diff_days = datediff(ds, @begin_y_test) where ds between @begin_y_test and @end_y_test;
-----------------------------------------------
--artist
--drop column
alter table mars_tianchi_features drop column r_artist_code;
alter table mars_tianchi_features drop column r_n_songs;
alter table mars_tianchi_features drop column r_gender;
alter table mars_tianchi_features drop column r_n_languages;
alter table mars_tianchi_features drop column r_mode_language;
alter table mars_tianchi_features drop column r_avg_plays;
alter table mars_tianchi_features drop column r_std_plays;
alter table mars_tianchi_features drop column r_cov_plays;
alter table mars_tianchi_features drop column r_plays;
alter table mars_tianchi_features drop column r_avg_plays_last_3_days;
alter table mars_tianchi_features drop column r_avg_plays_last_5_days;
alter table mars_tianchi_features drop column r_avg_plays_last_7_days;
alter table mars_tianchi_features drop column r_q2_plays_div_q1_plays;
alter table mars_tianchi_features drop column r_q3_plays_div_q2_plays;
alter table mars_tianchi_features drop column r_q4_plays_div_q3_plays;
alter table mars_tianchi_features drop column r_sum_plays;
alter table mars_tianchi_features drop column r_sum_downloads;
alter table mars_tianchi_features drop column r_sum_collects;
alter table mars_tianchi_features drop column r_sum_downloads_div_sum_plays;
alter table mars_tianchi_features drop column r_sum_collects_div_sum_plays;
--add column
alter table mars_tianchi_features add(r_artist_code int);
alter table mars_tianchi_features add(r_n_songs int);
alter table mars_tianchi_features add(r_gender int);
alter table mars_tianchi_features add(r_n_languages int);
alter table mars_tianchi_features add(r_mode_language int);
alter table mars_tianchi_features add(r_avg_plays float);
alter table mars_tianchi_features add(r_std_plays float);
alter table mars_tianchi_features add(r_cov_plays float);
alter table mars_tianchi_features add(r_plays float);
alter table mars_tianchi_features add(r_avg_plays_last_3_days float);
alter table mars_tianchi_features add(r_avg_plays_last_5_days float);
alter table mars_tianchi_features add(r_avg_plays_last_7_days float);
alter table mars_tianchi_features add (r_q2_plays_div_q1_plays float);
alter table mars_tianchi_features add (r_q3_plays_div_q2_plays float);
alter table mars_tianchi_features add (r_q4_plays_div_q3_plays float);
alter table mars_tianchi_features add (r_sum_plays int);
alter table mars_tianchi_features add (r_sum_downloads int);
alter table mars_tianchi_features add (r_sum_collects int);
alter table mars_tianchi_features add (r_sum_downloads_div_sum_plays float);
alter table mars_tianchi_features add (r_sum_collects_div_sum_plays float);
--all
update mars_tianchi_features left join mars_tianchi_artists 
on mars_tianchi_features.artist_id = mars_tianchi_artists.artist_id set 
mars_tianchi_features.r_artist_code = mars_tianchi_artists.artist_code,
mars_tianchi_features.r_n_songs = mars_tianchi_artists.n_songs,
mars_tianchi_features.r_gender = mars_tianchi_artists.gender,
mars_tianchi_features.r_n_languages = mars_tianchi_artists.n_languages,
mars_tianchi_features.r_mode_language = mars_tianchi_artists.mode_language;
--train
update mars_tianchi_features set mars_tianchi_features.r_avg_plays = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.ds between @begin_X_train and @end_X_train), 0) where mars_tianchi_features.ds between @begin_y_train and @end_y_train;
update mars_tianchi_features set mars_tianchi_features.r_std_plays = ifnull((select std(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.ds between @begin_X_train and @end_X_train), 0) where mars_tianchi_features.ds between @begin_y_train and @end_y_train;
update mars_tianchi_features set mars_tianchi_features.r_cov_plays = ifnull((select std(n) / avg(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.ds between @begin_X_train and @end_X_train), 0) where mars_tianchi_features.ds between @begin_y_train and @end_y_train;
update mars_tianchi_features set mars_tianchi_features.r_plays = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.ds = @end_X_train), 0) where mars_tianchi_features.ds between @begin_y_train and @end_y_train;
update mars_tianchi_features set mars_tianchi_features.r_avg_plays_last_3_days = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and datediff(@end_X_train, mars_tianchi_artist_actions.ds) between 0 and 2), 0) where mars_tianchi_features.ds between @begin_y_train and @end_y_train;
update mars_tianchi_features set mars_tianchi_features.r_avg_plays_last_5_days = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and datediff(@end_X_train, mars_tianchi_artist_actions.ds) between 0 and 4), 0) where mars_tianchi_features.ds between @begin_y_train and @end_y_train;
update mars_tianchi_features set mars_tianchi_features.r_avg_plays_last_7_days = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and datediff(@end_X_train, mars_tianchi_artist_actions.ds) between 0 and 6), 0) where mars_tianchi_features.ds between @begin_y_train and @end_y_train;
update mars_tianchi_features set mars_tianchi_features.r_q2_plays_div_q1_plays = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and datediff(@end_X_train, mars_tianchi_artist_actions.ds) between 15 and 29), 0) / ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and datediff(@end_X_train, mars_tianchi_artist_actions.ds) between 0 and 14), 0) where mars_tianchi_features.ds between @begin_y_train and @end_y_train;
update mars_tianchi_features set mars_tianchi_features.r_q3_plays_div_q2_plays = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and datediff(@end_X_train, mars_tianchi_artist_actions.ds) between 30 and 44), 0) / ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and datediff(@end_X_train, mars_tianchi_artist_actions.ds) between 15 and 29), 0) where mars_tianchi_features.ds between @begin_y_train and @end_y_train;
update mars_tianchi_features set mars_tianchi_features.r_q4_plays_div_q3_plays = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and datediff(@end_X_train, mars_tianchi_artist_actions.ds) between 45 and 59), 0) / ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and datediff(@end_X_train, mars_tianchi_artist_actions.ds) between 30 and 44), 0) where mars_tianchi_features.ds between @begin_y_train and @end_y_train;
update mars_tianchi_features set mars_tianchi_features.r_sum_plays = ifnull((select sum(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.ds between @begin_X_train and @end_X_train), 0) where mars_tianchi_features.ds between @begin_y_train and @end_y_train;
update mars_tianchi_features set mars_tianchi_features.r_sum_downloads = ifnull((select sum(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='2' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.ds between @begin_X_train and @end_X_train), 0) where mars_tianchi_features.ds between @begin_y_train and @end_y_train;
update mars_tianchi_features set mars_tianchi_features.r_sum_collects = ifnull((select sum(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='3' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.ds between @begin_X_train and @end_X_train), 0) where mars_tianchi_features.ds between @begin_y_train and @end_y_train;
update mars_tianchi_features set mars_tianchi_features.r_sum_downloads_div_sum_plays = ifnull((select sum(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='2' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.ds between @begin_X_train and @end_X_train), 0) / (ifnull((select sum(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.ds between @begin_X_train and @end_X_train), 0) + 1) where mars_tianchi_features.ds between @begin_y_train and @end_y_train;
update mars_tianchi_features set mars_tianchi_features.r_sum_collects_div_sum_plays = ifnull((select sum(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='3' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.ds between @begin_X_train and @end_X_train), 0) / (ifnull((select sum(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.ds between @begin_X_train and @end_X_train), 0) + 1) where mars_tianchi_features.ds between @begin_y_train and @end_y_train;
--test
update mars_tianchi_features set mars_tianchi_features.r_avg_plays = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.ds between @begin_X_test and @end_X_test), 0) where mars_tianchi_features.ds between @begin_y_test and @end_y_test;
update mars_tianchi_features set mars_tianchi_features.r_std_plays = ifnull((select std(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.ds between @begin_X_test and @end_X_test), 0) where mars_tianchi_features.ds between @begin_y_test and @end_y_test;
update mars_tianchi_features set mars_tianchi_features.r_cov_plays = ifnull((select std(n) / avg(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.ds between @begin_X_test and @end_X_test), 0) where mars_tianchi_features.ds between @begin_y_test and @end_y_test;
update mars_tianchi_features set mars_tianchi_features.r_plays = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.ds = @end_X_test), 0) where mars_tianchi_features.ds between @begin_y_test and @end_y_test;
update mars_tianchi_features set mars_tianchi_features.r_avg_plays_last_3_days = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and datediff(@end_X_test, mars_tianchi_artist_actions.ds) between 0 and 2), 0) where mars_tianchi_features.ds between @begin_y_test and @end_y_test;
update mars_tianchi_features set mars_tianchi_features.r_avg_plays_last_5_days = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and datediff(@end_X_test, mars_tianchi_artist_actions.ds) between 0 and 4), 0) where mars_tianchi_features.ds between @begin_y_test and @end_y_test;
update mars_tianchi_features set mars_tianchi_features.r_avg_plays_last_7_days = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and datediff(@end_X_test, mars_tianchi_artist_actions.ds) between 0 and 6), 0) where mars_tianchi_features.ds between @begin_y_test and @end_y_test;
update mars_tianchi_features set mars_tianchi_features.r_q2_plays_div_q1_plays = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and datediff(@end_X_test, mars_tianchi_artist_actions.ds) between 15 and 29), 0) / ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and datediff(@end_X_test, mars_tianchi_artist_actions.ds) between 0 and 14), 0) where mars_tianchi_features.ds between @begin_y_test and @end_y_test;
update mars_tianchi_features set mars_tianchi_features.r_q3_plays_div_q2_plays = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and datediff(@end_X_test, mars_tianchi_artist_actions.ds) between 30 and 44), 0) / ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and datediff(@end_X_test, mars_tianchi_artist_actions.ds) between 15 and 29), 0) where mars_tianchi_features.ds between @begin_y_test and @end_y_test;
update mars_tianchi_features set mars_tianchi_features.r_q4_plays_div_q3_plays = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and datediff(@end_X_test, mars_tianchi_artist_actions.ds) between 45 and 59), 0) / ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and datediff(@end_X_test, mars_tianchi_artist_actions.ds) between 30 and 44), 0) where mars_tianchi_features.ds between @begin_y_test and @end_y_test;
update mars_tianchi_features set mars_tianchi_features.r_sum_plays = ifnull((select sum(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.ds between @begin_X_test and @end_X_test), 0) where mars_tianchi_features.ds between @begin_y_test and @end_y_test;
update mars_tianchi_features set mars_tianchi_features.r_sum_downloads = ifnull((select sum(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='2' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.ds between @begin_X_test and @end_X_test), 0) where mars_tianchi_features.ds between @begin_y_test and @end_y_test;
update mars_tianchi_features set mars_tianchi_features.r_sum_collects = ifnull((select sum(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='3' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.ds between @begin_X_test and @end_X_test), 0) where mars_tianchi_features.ds between @begin_y_test and @end_y_test;
update mars_tianchi_features set mars_tianchi_features.r_sum_downloads_div_sum_plays = ifnull((select sum(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='2' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.ds between @begin_X_test and @end_X_test), 0) / (ifnull((select sum(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.ds between @begin_X_test and @end_X_test), 0) + 1) where mars_tianchi_features.ds between @begin_y_test and @end_y_test;
update mars_tianchi_features set mars_tianchi_features.r_sum_collects_div_sum_plays = ifnull((select sum(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='3' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.ds between @begin_X_test and @end_X_test), 0) / (ifnull((select sum(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.ds between @begin_X_test and @end_X_test), 0) + 1) where mars_tianchi_features.ds between @begin_y_test and @end_y_test;
-----------------------------------------------
--artist & day
--drop column
alter table mars_tianchi_features drop column r_avg_plays_weekday;
--add column
alter table mars_tianchi_features add(r_avg_plays_weekday float);
--train
update mars_tianchi_features set mars_tianchi_features.r_avg_plays_weekday = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and dayofweek(mars_tianchi_features.ds) = dayofweek(mars_tianchi_artist_actions.ds) and mars_tianchi_artist_actions.ds between @begin_X_train and @end_X_train), 0) where mars_tianchi_features.ds between @begin_y_train and @end_y_train;
--test
update mars_tianchi_features set mars_tianchi_features.r_avg_plays_weekday = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and dayofweek(mars_tianchi_features.ds) = dayofweek(mars_tianchi_artist_actions.ds) and mars_tianchi_artist_actions.ds between @begin_X_test and @end_X_test), 0) where mars_tianchi_features.ds between @begin_y_test and @end_y_test;
