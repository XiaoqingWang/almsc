set @begin_train:=(select min(ds) from mars_tianchi_features where is_train = '1');
set @end_train:=(select max(ds) from mars_tianchi_features where is_train = '1');
set @begin_test:=(select min(ds) from mars_tianchi_features where is_train = '0');
set @end_test:=(select max(ds) from mars_tianchi_features where is_train = '0');
-----------------------------------------------
drop table if exists mars_tianchi_series;
create table mars_tianchi_series
(
artist_id char(32),
ds char(8),
name varchar(256),
val float,
primary key(artist_id, ds, name)
);
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'plays' as name from mars_tianchi_artists, mars_tianchi_ds where mars_tianchi_ds.ds;
update mars_tianchi_series left join mars_tianchi_artist_actions on mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds and mars_tianchi_artist_actions.action_type = '1' set mars_tianchi_series.val = mars_tianchi_artist_actions.n where mars_tianchi_series.name = 'plays';
-----------------------------------------------
drop table if exists mars_tianchi_series_correlation;
create table mars_tianchi_series_correlation
(
artist_id char(32),
name varchar(256),
n_days int,
offset int,
correlation float,
primary key(artist_id, name)
);
-----------------------------------------------
