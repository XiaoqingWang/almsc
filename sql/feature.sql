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
select @begin_ds_train:=min(ds) from mars_tianchi_features where is_train = '1';
select @begin_ds_test:=min(ds) from mars_tianchi_features where is_train = '0';
select @begin_week_train:=week(min(ds), 0) from mars_tianchi_features where is_train = '1';
select @begin_week_test:=week(min(ds), 0) from mars_tianchi_features where is_train = '0';
select @begin_month_train:=month(min(ds)) from mars_tianchi_features where is_train = '1';
select @begin_month_test:=month(min(ds)) from mars_tianchi_features where is_train = '0';
--drop column
alter table mars_tianchi_features drop column artist_code;
alter table mars_tianchi_features drop column plays_last_1_week;
alter table mars_tianchi_features drop column plays_last_2_week;
alter table mars_tianchi_features drop column plays_last_3_week;
alter table mars_tianchi_features drop column plays_last_4_week;
alter table mars_tianchi_features drop column plays_last_5_week;
alter table mars_tianchi_features drop column n_songs;
alter table mars_tianchi_features drop column gender;
alter table mars_tianchi_features drop column n_languages;
alter table mars_tianchi_features drop column mode_language;
alter table mars_tianchi_features drop column avg_artist_song_plays_last_1_month;
alter table mars_tianchi_features drop column std_artist_song_plays_last_1_month;
alter table mars_tianchi_features drop column avg_artist_song_plays_last_2_month;
alter table mars_tianchi_features drop column std_artist_song_plays_last_2_month;
alter table mars_tianchi_features drop column offset_first_song;
alter table mars_tianchi_features drop column offset_last_song;
alter table mars_tianchi_features drop column avg_plays_same_weekday;
alter table mars_tianchi_features drop column avg_plays_same_week;
--add column
alter table mars_tianchi_features add(artist_code int);
alter table mars_tianchi_features add(plays_last_1_week int);
alter table mars_tianchi_features add(plays_last_2_week int);
alter table mars_tianchi_features add(plays_last_3_week int);
alter table mars_tianchi_features add(plays_last_4_week int);
alter table mars_tianchi_features add(plays_last_5_week int);
alter table mars_tianchi_features add(n_songs int);
alter table mars_tianchi_features add(gender int);
alter table mars_tianchi_features add(n_languages int);
alter table mars_tianchi_features add(mode_language int);
alter table mars_tianchi_features add(avg_artist_song_plays_last_1_month float);
alter table mars_tianchi_features add(std_artist_song_plays_last_1_month float);
alter table mars_tianchi_features add(avg_artist_song_plays_last_2_month float);
alter table mars_tianchi_features add(std_artist_song_plays_last_2_month float);
alter table mars_tianchi_features add (offset_first_song int);
alter table mars_tianchi_features add (offset_last_song int);
alter table mars_tianchi_features add (avg_plays_same_weekday int);
alter table mars_tianchi_features add (avg_plays_same_day int);
--all
update mars_tianchi_features left join mars_tianchi_artists 
on mars_tianchi_features.artist_id = mars_tianchi_artists.artist_id set 
mars_tianchi_features.artist_code = mars_tianchi_artists.artist_code,
mars_tianchi_features.n_songs = mars_tianchi_artists.n_songs,
mars_tianchi_features.gender = mars_tianchi_artists.gender,
mars_tianchi_features.n_languages = mars_tianchi_artists.n_languages,
mars_tianchi_features.mode_language = mars_tianchi_artists.mode_language;

--train
update mars_tianchi_features set mars_tianchi_features.plays_last_1_week = (select sum_n from mars_tianchi_artist_week_actions where mars_tianchi_artist_week_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_week_actions.artist_id and @begin_week_train - mars_tianchi_artist_week_actions.week = 1) where mars_tianchi_features.is_train = '1';
update mars_tianchi_features set mars_tianchi_features.plays_last_3_week = (select sum_n from mars_tianchi_artist_week_actions where mars_tianchi_artist_week_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_week_actions.artist_id and @begin_week_train - mars_tianchi_artist_week_actions.week = 2) where mars_tianchi_features.is_train = '1';
update mars_tianchi_features set mars_tianchi_features.plays_last_3_week = (select sum_n from mars_tianchi_artist_week_actions where mars_tianchi_artist_week_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_week_actions.artist_id and @begin_week_train - mars_tianchi_artist_week_actions.week = 3) where mars_tianchi_features.is_train = '1';
update mars_tianchi_features set mars_tianchi_features.plays_last_4_week = (select sum_n from mars_tianchi_artist_week_actions where mars_tianchi_artist_week_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_week_actions.artist_id and @begin_week_train - mars_tianchi_artist_week_actions.week = 4) where mars_tianchi_features.is_train = '1';
update mars_tianchi_features set mars_tianchi_features.plays_last_5_week = (select sum_n from mars_tianchi_artist_week_actions where mars_tianchi_artist_week_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_week_actions.artist_id and @begin_week_train - mars_tianchi_artist_week_actions.week = 5) where mars_tianchi_features.is_train = '1';
update mars_tianchi_features set mars_tianchi_features.avg_artist_song_plays_last_1_month = (select avg_n from mars_tianchi_artist_song_month_actions where mars_tianchi_artist_month_song_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_month_song_actions.artist_id and @begin_month_train - mars_tianchi_artist_month_song_actions.month = 1) where mars_tianchi_features.is_train = '1';
update mars_tianchi_features set mars_tianchi_features.std_artist_song_plays_last_1_month = (select std_n from mars_tianchi_artist_month_song_actions where mars_tianchi_artist_month_song_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_month_song_actions.artist_id and @begin_month_train - mars_tianchi_artist_month_song_actions.month = 1) where mars_tianchi_features.is_train = '1';
update mars_tianchi_features set mars_tianchi_features.avg_artist_song_plays_last_2_month = (select avg_n from mars_tianchi_artist_month_song_actions where mars_tianchi_artist_month_song_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_month_song_actions.artist_id and @begin_month_train - mars_tianchi_artist_month_song_actions.month = 2) where mars_tianchi_features.is_train = '1';
update mars_tianchi_features set mars_tianchi_features.std_artist_song_plays_last_2_month = (select std_n from mars_tianchi_artist_month_song_actions where mars_tianchi_artist_month_song_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_month_song_actions.artist_id and @begin_month_train - mars_tianchi_artist_month_song_actions.month = 2) where mars_tianchi_features.is_train = '1';
update mars_tianchi_features set mars_tianchi_features.offset_first_song = ifnull((select timestampdiff(day, min(publish_time), @begin_ds_train) from mars_tianchi_songs where mars_tianchi_songs.publish_time < @begin_ds_train and mars_tianchi_features.artist_id = mars_tianchi_songs.artist_id), -1) where mars_tianchi_features.is_train = '1';
update mars_tianchi_features set mars_tianchi_features.offset_last_song = ifnull((select timestampdiff(day, max(publish_time), @begin_ds_train) from mars_tianchi_songs where mars_tianchi_songs.publish_time < @begin_ds_train and mars_tianchi_features.artist_id = mars_tianchi_songs.artist_id), -1) where mars_tianchi_features.is_train = '1';
update mars_tianchi_features set mars_tianchi_features.avg_plays_same_weekday = (select avg(avg_n) from mars_tianchi_artist_month_weekday_actions where mars_tianchi_artist_month_weekday_actions.action_type = '1' and mars_tianchi_features.artist_id = mars_tianchi_artist_month_weekday_actions.artist_id and dayofweek(mars_tianchi_features.ds) = mars_tianchi_artist_month_weekday_actions.weekday and @begin_month_train - mars_tianchi_artist_month_weekday_actions.month between 1 and 2) where mars_tianchi_features.is_train = '1';
update mars_tianchi_features set mars_tianchi_features.avg_plays_same_day = (select avg(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and dayofmonth(mars_tianchi_features.ds) = dayofmonth(mars_tianchi_artist_actions.ds) and @begin_month_train - month(mars_tianchi_artist_actions.ds) between 1 and 2) where mars_tianchi_features.is_train = '1';

--test
update mars_tianchi_features set mars_tianchi_features.plays_last_1_week = (select sum_n from mars_tianchi_artist_week_actions where mars_tianchi_artist_week_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_week_actions.artist_id and @begin_week_test - mars_tianchi_artist_week_actions.week = 1);
update mars_tianchi_features set mars_tianchi_features.plays_last_2_week = (select sum_n from mars_tianchi_artist_week_actions where mars_tianchi_artist_week_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_week_actions.artist_id and @begin_week_test - mars_tianchi_artist_week_actions.week = 2);
update mars_tianchi_features set mars_tianchi_features.plays_last_3_week = (select sum_n from mars_tianchi_artist_week_actions where mars_tianchi_artist_week_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_week_actions.artist_id and @begin_week_test - mars_tianchi_artist_week_actions.week = 3);
update mars_tianchi_features set mars_tianchi_features.plays_last_4_week = (select sum_n from mars_tianchi_artist_week_actions where mars_tianchi_artist_week_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_week_actions.artist_id and @begin_week_test - mars_tianchi_artist_week_actions.week = 4);
update mars_tianchi_features set mars_tianchi_features.plays_last_5_week = (select sum_n from mars_tianchi_artist_week_actions where mars_tianchi_artist_week_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_week_actions.artist_id and @begin_week_test - mars_tianchi_artist_week_actions.week = 5);
update mars_tianchi_features set mars_tianchi_features.avg_artist_song_plays_last_1_month = (select avg_n from mars_tianchi_artist_month_song_actions where mars_tianchi_artist_month_song_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_month_song_actions.artist_id and @begin_month_test - mars_tianchi_artist_month_song_actions.month = 1);
update mars_tianchi_features set mars_tianchi_features.std_artist_song_plays_last_1_month = (select std_n from mars_tianchi_artist_month_song_actions where mars_tianchi_artist_month_song_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_month_song_actions.artist_id and @begin_month_test - mars_tianchi_artist_month_song_actions.month = 1);
update mars_tianchi_features set mars_tianchi_features.avg_artist_song_plays_last_2_month = (select avg_n from mars_tianchi_artist_month_song_actions where mars_tianchi_artist_month_song_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_month_song_actions.artist_id and @begin_month_test - mars_tianchi_artist_month_song_actions.month = 2);
update mars_tianchi_features set mars_tianchi_features.std_artist_song_plays_last_2_month = (select std_n from mars_tianchi_artist_month_song_actions where mars_tianchi_artist_month_song_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_month_song_actions.artist_id and @begin_month_test - mars_tianchi_artist_month_song_actions.month = 2);
update mars_tianchi_features set mars_tianchi_features.offset_first_song = ifnull((select timestampdiff(day, min(publish_time), @begin_ds_train) from mars_tianchi_songs where mars_tianchi_songs.publish_time < @begin_ds_test and mars_tianchi_features.artist_id = mars_tianchi_songs.artist_id), -1);
update mars_tianchi_features set mars_tianchi_features.offset_last_song = ifnull((select timestampdiff(day, max(publish_time), @begin_ds_train) from mars_tianchi_songs where mars_tianchi_songs.publish_time < @begin_ds_test and mars_tianchi_features.artist_id = mars_tianchi_songs.artist_id), -1) where mars_tianchi_features.is_train = '0';
update mars_tianchi_features set mars_tianchi_features.avg_plays_same_weekday = (select avg(avg_n) from mars_tianchi_artist_month_weekday_actions where mars_tianchi_artist_month_weekday_actions.action_type = '1' and mars_tianchi_features.artist_id = mars_tianchi_artist_month_weekday_actions.artist_id and dayofweek(mars_tianchi_features.ds) = mars_tianchi_artist_month_weekday_actions.weekday and @begin_month_test - mars_tianchi_artist_month_weekday_actions.month between 1 and 2) where mars_tianchi_features.is_train = '0';
update mars_tianchi_features set mars_tianchi_features.avg_plays_same_day = (select avg(n) from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_features.artist_id = mars_tianchi_artist_actions.artist_id and dayofmonth(mars_tianchi_features.ds) = dayofmonth(mars_tianchi_artist_actions.ds) and @begin_month_test - month(mars_tianchi_artist_actions.ds) between 1 and 2) where mars_tianchi_features.is_train = '0';

--artist&day
select @begin_day_train:=min(ds) from mars_tianchi_features where is_train = '1';
select @begin_day_test:=min(ds) from mars_tianchi_features where is_train = '0';
