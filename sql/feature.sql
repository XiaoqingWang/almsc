set @begin_X_train:=(select min(ds) from mars_tianchi_samples where is_X = 1 and is_train = 1);
set @end_X_train:=(select max(ds) from mars_tianchi_samples where is_X = 1 and is_train = 1);
set @begin_y_train:=(select min(ds) from mars_tianchi_samples where is_X = 0 and is_train = 1);
set @end_y_train:=(select max(ds) from mars_tianchi_samples where is_X = 0 and is_train = 1);
set @begin_X_test:=(select min(ds) from mars_tianchi_samples where is_X = 1 and is_train = 0);
set @end_X_test:=(select max(ds) from mars_tianchi_samples where is_X = 1 and is_train = 0);
set @begin_y_test:=(select min(ds) from mars_tianchi_samples where is_X = 0 and is_train = 0);
set @end_y_test:=(select max(ds) from mars_tianchi_samples where is_X = 0 and is_train = 0);
set @end_week_X_train:=(select week(max(ds), 0) from mars_tianchi_samples where is_X = 1 and is_train = 1);
set @end_week_X_test:=(select week(max(ds), 0) from mars_tianchi_samples where is_X = 1 and is_train = 0);
-----------------------------------------------
drop table if exists mars_tianchi_features;
create table mars_tianchi_features
(
artist_id char(32),
ds char(8),
primary key(artist_id, ds)
);
insert into mars_tianchi_features(artist_id, ds) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds from mars_tianchi_artists, mars_tianchi_ds;
--time
--drop column
alter table mars_tianchi_features drop column month;
alter table mars_tianchi_features drop column day;
alter table mars_tianchi_features drop column season;
alter table mars_tianchi_features drop column week;
alter table mars_tianchi_features drop column weekday;
alter table mars_tianchi_features drop column is_holiday;
alter table mars_tianchi_features drop column n_holidays;
alter table mars_tianchi_features drop column i_holidays; 
alter table mars_tianchi_features drop column is_good_voice;
alter table mars_tianchi_features drop column is_music_festival;
--add column
alter table mars_tianchi_features add (month int);
alter table mars_tianchi_features add (day int);
alter table mars_tianchi_features add (season int);
alter table mars_tianchi_features add (week int);
alter table mars_tianchi_features add (weekday int);
alter table mars_tianchi_features add (is_holiday int);
alter table mars_tianchi_features add (n_holidays int);
alter table mars_tianchi_features add (i_holidays int);
alter table mars_tianchi_features add (is_good_voice int);
alter table mars_tianchi_features add (is_music_festival int);
--all
update mars_tianchi_features
left join mars_tianchi_ds on mars_tianchi_features.ds = mars_tianchi_ds.ds set
mars_tianchi_features.month = mars_tianchi_ds.month,
mars_tianchi_features.day = mars_tianchi_ds.day,
mars_tianchi_features.season = mars_tianchi_ds.season,
mars_tianchi_features.week = mars_tianchi_ds.week,
mars_tianchi_features.weekday = mars_tianchi_ds.weekday,
mars_tianchi_features.is_holiday = mars_tianchi_ds.is_holiday,
mars_tianchi_features.n_holidays = mars_tianchi_ds.n_holidays,
mars_tianchi_features.i_holidays = mars_tianchi_ds.i_holidays,
mars_tianchi_features.is_good_voice = mars_tianchi_ds.is_good_voice,
mars_tianchi_features.is_music_festival = mars_tianchi_ds.is_music_festival;

--artist
--drop column
alter table mars_tianchi_features drop column artist_code;
alter table mars_tianchi_features drop column n_songs;
alter table mars_tianchi_features drop column gender;
alter table mars_tianchi_features drop column n_languages;
alter table mars_tianchi_features drop column mode_language;
alter table mars_tianchi_features drop column plays_last_1_week;
alter table mars_tianchi_features drop column plays_last_2_week;
alter table mars_tianchi_features drop column plays_last_3_week;
alter table mars_tianchi_features drop column plays_last_4_week;
alter table mars_tianchi_features drop column plays_last_5_week;
--add column
alter table mars_tianchi_features add(artist_code int);
alter table mars_tianchi_features add(n_songs int);
alter table mars_tianchi_features add(gender int);
alter table mars_tianchi_features add(n_languages int);
alter table mars_tianchi_features add(mode_language int);
alter table mars_tianchi_features add(plays_last_1_week int);
alter table mars_tianchi_features add(plays_last_2_week int);
alter table mars_tianchi_features add(plays_last_3_week int);
alter table mars_tianchi_features add(plays_last_4_week int);
alter table mars_tianchi_features add(plays_last_5_week int);
--all
update mars_tianchi_features left join mars_tianchi_artists 
on mars_tianchi_features.artist_id = mars_tianchi_artists.artist_id set 
mars_tianchi_features.artist_code = mars_tianchi_artists.artist_code,
mars_tianchi_features.n_songs = mars_tianchi_artists.n_songs,
mars_tianchi_features.gender = mars_tianchi_artists.gender,
mars_tianchi_features.n_languages = mars_tianchi_artists.n_languages,
mars_tianchi_features.mode_language = mars_tianchi_artists.mode_language;
--train
update mars_tianchi_features set mars_tianchi_features.plays_last_1_week = (select sum_n from mars_tianchi_artist_week_actions where mars_tianchi_artist_week_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_week_actions.artist_id and @end_week_X_train - mars_tianchi_artist_week_actions.week = 1) where mars_tianchi_features.ds between @begin_y_train and @end_y_train;
update mars_tianchi_features set mars_tianchi_features.plays_last_2_week = (select sum_n from mars_tianchi_artist_week_actions where mars_tianchi_artist_week_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_week_actions.artist_id and @end_week_X_train - mars_tianchi_artist_week_actions.week = 2) where mars_tianchi_features.ds between @begin_y_train and @end_y_train;
update mars_tianchi_features set mars_tianchi_features.plays_last_3_week = (select sum_n from mars_tianchi_artist_week_actions where mars_tianchi_artist_week_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_week_actions.artist_id and @end_week_X_train - mars_tianchi_artist_week_actions.week = 3) where mars_tianchi_features.ds between @begin_y_train and @end_y_train;
update mars_tianchi_features set mars_tianchi_features.plays_last_4_week = (select sum_n from mars_tianchi_artist_week_actions where mars_tianchi_artist_week_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_week_actions.artist_id and @end_week_X_train - mars_tianchi_artist_week_actions.week = 4) where mars_tianchi_features.ds between @begin_y_train and @end_y_train;
update mars_tianchi_features set mars_tianchi_features.plays_last_5_week = (select sum_n from mars_tianchi_artist_week_actions where mars_tianchi_artist_week_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_week_actions.artist_id and @end_week_X_train - mars_tianchi_artist_week_actions.week = 5) where mars_tianchi_features.ds between @begin_y_train and @end_y_train;
--test
update mars_tianchi_features set mars_tianchi_features.plays_last_1_week = (select sum_n from mars_tianchi_artist_week_actions where mars_tianchi_artist_week_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_week_actions.artist_id and @end_week_X_test - mars_tianchi_artist_week_actions.week = 1) where mars_tianchi_features.ds between @begin_y_test and @end_y_test;
update mars_tianchi_features set mars_tianchi_features.plays_last_2_week = (select sum_n from mars_tianchi_artist_week_actions where mars_tianchi_artist_week_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_week_actions.artist_id and @end_week_X_test - mars_tianchi_artist_week_actions.week = 2) where mars_tianchi_features.ds between @begin_y_test and @end_y_test;
update mars_tianchi_features set mars_tianchi_features.plays_last_3_week = (select sum_n from mars_tianchi_artist_week_actions where mars_tianchi_artist_week_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_week_actions.artist_id and @end_week_X_test - mars_tianchi_artist_week_actions.week = 3) where mars_tianchi_features.ds between @begin_y_test and @end_y_test;
update mars_tianchi_features set mars_tianchi_features.plays_last_4_week = (select sum_n from mars_tianchi_artist_week_actions where mars_tianchi_artist_week_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_week_actions.artist_id and @end_week_X_test - mars_tianchi_artist_week_actions.week = 4) where mars_tianchi_features.ds between @begin_y_test and @end_y_test;
update mars_tianchi_features set mars_tianchi_features.plays_last_5_week = (select sum_n from mars_tianchi_artist_week_actions where mars_tianchi_artist_week_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_week_actions.artist_id and @end_week_X_test - mars_tianchi_artist_week_actions.week = 5) where mars_tianchi_features.ds between @begin_y_test and @end_y_test;
