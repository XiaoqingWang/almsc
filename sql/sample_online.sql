--20150501 is ignored
set @begin_X_train:='20150502';
set @end_X_train:='20150630';
--20150701 is ignored
set @begin_y_train:='20150702';
set @end_y_train:='20150830';
--20150701 is ignored
set @begin_X_test:='20150702';
set @end_X_test:='20150830';
--20150831 is ignored
set @begin_y_test:='20150901';
set @end_y_test:='20151030';

--sample
drop table if exists mars_tianchi_samples;
create table mars_tianchi_samples
(
artist_id char(32),
ds char(8),
is_X int, -- 1:X,0:y
is_train int, --1:train,0:test
plays int,
primary key(artist_id, ds, is_X, is_train)
);
insert into mars_tianchi_samples(artist_id, ds, is_X, is_train) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, '1' as is_X, '1' as is_train from mars_tianchi_artists, mars_tianchi_ds where mars_tianchi_ds.ds between @begin_X_train and @end_X_train;
insert into mars_tianchi_samples(artist_id, ds, is_X, is_train) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, '0' as is_X, '1' as is_train from mars_tianchi_artists, mars_tianchi_ds where mars_tianchi_ds.ds between @begin_y_train and @end_y_train;
insert into mars_tianchi_samples(artist_id, ds, is_X, is_train) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, '1' as is_X, '0' as is_train from mars_tianchi_artists, mars_tianchi_ds where mars_tianchi_ds.ds between @begin_X_test and @end_X_test;
insert into mars_tianchi_samples(artist_id, ds, is_X, is_train) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, '0' as is_X, '0' as is_train from mars_tianchi_artists, mars_tianchi_ds where mars_tianchi_ds.ds between @begin_y_test and @end_y_test;
update mars_tianchi_samples left join mars_tianchi_artist_actions on mars_tianchi_samples.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_samples.ds = mars_tianchi_artist_actions.ds and mars_tianchi_artist_actions.action_type = '1' set mars_tianchi_samples.plays = ifnull(mars_tianchi_artist_actions.n, 0);
--select * from mars_tianchi_samples

--abnormal
drop table if exists mars_tianchi_samples_artist_statics;
create table mars_tianchi_samples_artist_statics
(
artist_id char(32),
is_X int, -- 1:X,0:y
is_train int, --1:train,0:test
sum_plays int,
max_plays int,
min_plays int,
avg_plays float,
std_plays float,
top float,
bottom float,
primary key(artist_id, is_X, is_train)
);
insert into mars_tianchi_samples_artist_statics select artist_id, is_X, is_train, sum(plays) as sum_plays, max(plays) as max_plays, min(plays) as min_plays, avg(plays) as avg_plays, std(plays) as std_plays, (avg(plays) + 2 * std(plays)) as top, (avg(plays) - 2 * std(plays))  as bottom from mars_tianchi_samples group by artist_id, is_X, is_train;
--select * from mars_tianchi_samples_artist_statics
select * from mars_tianchi_samples 
--delete from mars_tianchi_samples 
where not exists (select 1 from mars_tianchi_samples_artist_statics where mars_tianchi_samples_artist_statics.artist_id = mars_tianchi_samples.artist_id and mars_tianchi_samples_artist_statics.is_X = mars_tianchi_samples.is_X and mars_tianchi_samples_artist_statics.is_train = mars_tianchi_samples.is_train and mars_tianchi_samples.plays between mars_tianchi_samples_artist_statics.bottom and top) and is_X = 0 and is_train = 1;
select * from mars_tianchi_features
--delete from mars_tianchi_features
where not exists (select 1 from mars_tianchi_samples where mars_tianchi_samples.is_X = 0 and mars_tianchi_samples.artist_id = mars_tianchi_features.artist_id and mars_tianchi_samples.ds = mars_tianchi_features.ds);