--time
alter table mars_tianchi_features drop column month, drop column day, drop column season, drop column week, drop column weekday, drop column holiday, drop column n_holidays, drop column i_holidays; 
alter table mars_tianchi_features add (month int, day int, season int, week int, weekday int, holiday int, n_holidays int, i_holidays int);
update mars_tianchi_features
left join mars_tianchi_ds on mars_tianchi_features.ds = mars_tianchi_ds.ds set
mars_tianchi_features.month = mars_tianchi_ds.month,
mars_tianchi_features.day = mars_tianchi_ds.day,
mars_tianchi_features.season = mars_tianchi_ds.season,
mars_tianchi_features.week = mars_tianchi_ds.week,
mars_tianchi_features.weekday = mars_tianchi_ds.weekday,
mars_tianchi_features.holiday = mars_tianchi_ds.holiday,
mars_tianchi_features.n_holidays = mars_tianchi_ds.n_holidays,
mars_tianchi_features.i_holidays = mars_tianchi_ds.i_holidays;

--artist
select @begin_week_train:=week(min(ds), 0) from mars_tianchi_features where is_train = '1';
select @begin_week_test:=week(min(ds), 0) from mars_tianchi_features where is_train = '0';
select @begin_month_train:=month(min(ds)) from mars_tianchi_features where is_train = '1';
select @begin_month_test:=month(min(ds)) from mars_tianchi_features where is_train = '0';
--drop column
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
--add column
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

--all
update mars_tianchi_features left join mars_tianchi_artists 
on mars_tianchi_features.artist_id = mars_tianchi_artists.artist_id set 
mars_tianchi_features.n_songs = mars_tianchi_artists.n_songs,
mars_tianchi_features.gender = mars_tianchi_artists.gender,
mars_tianchi_features.n_languages = mars_tianchi_artists.n_languages,
mars_tianchi_features.mode_language = mars_tianchi_artists.mode_language;

--train
update mars_tianchi_features set
mars_tianchi_features.plays_last_1_week = (select sum_n from mars_tianchi_artist_week_actions where mars_tianchi_artist_week_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_week_actions.artist_id and @begin_week_train - mars_tianchi_artist_week_actions.week = 1),
mars_tianchi_features.plays_last_2_week = (select sum_n from mars_tianchi_artist_week_actions where mars_tianchi_artist_week_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_week_actions.artist_id and @begin_week_train - mars_tianchi_artist_week_actions.week = 2),
mars_tianchi_features.plays_last_3_week = (select sum_n from mars_tianchi_artist_week_actions where mars_tianchi_artist_week_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_week_actions.artist_id and @begin_week_train - mars_tianchi_artist_week_actions.week = 3),
mars_tianchi_features.plays_last_4_week = (select sum_n from mars_tianchi_artist_week_actions where mars_tianchi_artist_week_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_week_actions.artist_id and @begin_week_train - mars_tianchi_artist_week_actions.week = 4),
mars_tianchi_features.plays_last_5_week = (select sum_n from mars_tianchi_artist_week_actions where mars_tianchi_artist_week_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_week_actions.artist_id and @begin_week_train - mars_tianchi_artist_week_actions.week = 5),
mars_tianchi_features.avg_artist_song_plays_last_1_month = (select avg_n from mars_tianchi_artist_song_month_actions where mars_tianchi_artist_song_month_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_song_month_actions.artist_id and @begin_month_train - mars_tianchi_artist_song_month_actions.month = 1),
mars_tianchi_features.std_artist_song_plays_last_1_month = (select std_n from mars_tianchi_artist_song_month_actions where mars_tianchi_artist_song_month_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_song_month_actions.artist_id and @begin_month_train - mars_tianchi_artist_song_month_actions.month = 1),
mars_tianchi_features.avg_artist_song_plays_last_2_month = (select avg_n from mars_tianchi_artist_song_month_actions where mars_tianchi_artist_song_month_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_song_month_actions.artist_id and @begin_month_train - mars_tianchi_artist_song_month_actions.month = 2),
mars_tianchi_features.std_artist_song_plays_last_2_month = (select std_n from mars_tianchi_artist_song_month_actions where mars_tianchi_artist_song_month_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_song_month_actions.artist_id and @begin_month_train - mars_tianchi_artist_song_month_actions.month = 2)
where mars_tianchi_features.is_train = '1';
--test
update mars_tianchi_features set
mars_tianchi_features.plays_last_1_week = (select sum_n from mars_tianchi_artist_week_actions where mars_tianchi_artist_week_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_week_actions.artist_id and @begin_week_test - mars_tianchi_artist_week_actions.week = 1),
mars_tianchi_features.plays_last_2_week = (select sum_n from mars_tianchi_artist_week_actions where mars_tianchi_artist_week_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_week_actions.artist_id and @begin_week_test - mars_tianchi_artist_week_actions.week = 2),
mars_tianchi_features.plays_last_3_week = (select sum_n from mars_tianchi_artist_week_actions where mars_tianchi_artist_week_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_week_actions.artist_id and @begin_week_test - mars_tianchi_artist_week_actions.week = 3),
mars_tianchi_features.plays_last_4_week = (select sum_n from mars_tianchi_artist_week_actions where mars_tianchi_artist_week_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_week_actions.artist_id and @begin_week_test - mars_tianchi_artist_week_actions.week = 4),
mars_tianchi_features.plays_last_5_week = (select sum_n from mars_tianchi_artist_week_actions where mars_tianchi_artist_week_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_week_actions.artist_id and @begin_week_test - mars_tianchi_artist_week_actions.week = 5),
mars_tianchi_features.avg_artist_song_plays_last_1_month = (select avg_n from mars_tianchi_artist_song_month_actions where mars_tianchi_artist_song_month_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_song_month_actions.artist_id and @begin_month_test - mars_tianchi_artist_song_month_actions.month = 1),
mars_tianchi_features.std_artist_song_plays_last_1_month = (select std_n from mars_tianchi_artist_song_month_actions where mars_tianchi_artist_song_month_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_song_month_actions.artist_id and @begin_month_test - mars_tianchi_artist_song_month_actions.month = 1),
mars_tianchi_features.avg_artist_song_plays_last_2_month = (select avg_n from mars_tianchi_artist_song_month_actions where mars_tianchi_artist_song_month_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_song_month_actions.artist_id and @begin_month_test - mars_tianchi_artist_song_month_actions.month = 2),
mars_tianchi_features.std_artist_song_plays_last_2_month = (select std_n from mars_tianchi_artist_song_month_actions where mars_tianchi_artist_song_month_actions.action_type='1' and mars_tianchi_features.artist_id = mars_tianchi_artist_song_month_actions.artist_id and @begin_month_test - mars_tianchi_artist_song_month_actions.month = 2)
where mars_tianchi_features.is_train = '0';

--artist&day
select @begin_day_train:=min(ds) from mars_tianchi_features where is_train = '1';
select @begin_day_test:=min(ds) from mars_tianchi_features where is_train = '0';
