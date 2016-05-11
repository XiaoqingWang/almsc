drop table if exists mars_tianchi_features;
create table mars_tianchi_features
(
artist_id char(32),
ds char(8),
primary key(artist_id, ds)
);
insert into mars_tianchi_features(artist_id, ds) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds from mars_tianchi_artists, mars_tianchi_ds;
--select * from mars_tianchi_features
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