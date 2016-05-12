--20150302 is ignored
set @begin_X_train:='20150302';
set @end_X_train:='20150430';
set @begin_y_train:='20150502';
set @end_y_train:='20150630';
--20150501 is ignored
set @begin_X_test:='20150502';
set @end_X_test:='20150630';
--20150701 is ignored
set @begin_y_test:='20150702';
set @end_y_test:='20150830';

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
update mars_tianchi_samples left join mars_tianchi_artist_actions on mars_tianchi_samples.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_samples.ds = mars_tianchi_artist_actions.ds and mars_tianchi_artist_actions.action_type = '1' set mars_tianchi_samples.plays = mars_tianchi_artist_actions.n;
--select * from mars_tianchi_samples