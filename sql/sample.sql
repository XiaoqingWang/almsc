set @begin_X_train:='20150301';
set @end_X_train:='20150430';
set @begin_y_train:='20150501';
set @end_y_train:='20150630';
set @begin_X_test:='20150501';
set @end_X_test:='20150630';
set @begin_y_test:='20150701';
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




--delete abnormal artist
select * 
--delete 
from mars_tianchi_features where
is_train = '1' and artist_id in ('4b8eb68442432c242e9242be040bacf9', 'c5f0170f87a2fbb17bf65dc858c745e2', '2e14d32266ee6b4678595f8f50c369ac');

--delete abnormal day
select * 
--delete 
from mars_tianchi_features where
is_train = '1' and ds in ('');

--delete abnormal artist and day
/*
delete from mars_tianchi_features where artist_id = '023406156015ef87f99521f3b343f71f' and ds = '20150514';
delete from mars_tianchi_features where artist_id = '03c6699ea836decbc5c8fc2dbae7bd3b' and ds = '20150501';
delete from mars_tianchi_features where artist_id = '03c6699ea836decbc5c8fc2dbae7bd3b' and ds = '20150616';
delete from mars_tianchi_features where artist_id = '099cd99056bf92e5f0e384465890a804' and ds = '20150615';
delete from mars_tianchi_features where artist_id = '0c80008b0a28d356026f4b1097041689' and ds = '20150515';
delete from mars_tianchi_features where artist_id = '1339f978614ff19cd48f07e5420556d4' and ds = '20150621';
delete from mars_tianchi_features where artist_id = '25739ad1c56a511fcac86018ac4e49bb' and ds = '20150629';
delete from mars_tianchi_features where artist_id = '28e32be6ba67e0c6fdfdff80ce07dfd4' and ds = '20150627';
delete from mars_tianchi_features where artist_id = '2b7fedeea967becd9408b896de8ff903' and ds = '20150626';
delete from mars_tianchi_features where artist_id = '2b7fedeea967becd9408b896de8ff903' and ds = '20150627';
delete from mars_tianchi_features where artist_id = '2e14d32266ee6b4678595f8f50c369ac' and ds = '20150625';
delete from mars_tianchi_features where artist_id = '2ec1450a1389d4e3fc2a9a76c9378bb3' and ds = '20150628';
delete from mars_tianchi_features where artist_id = '33fd0a2cfcfd24e114707bba71ca1de9' and ds = '20150518';
delete from mars_tianchi_features where artist_id = '3964ee41d4e2ade1957a9135afe1b8dc' and ds = '20150611';
delete from mars_tianchi_features where artist_id = '3e395c6b799d3d8cb7cd501b4503b536' and ds = '20150513';
delete from mars_tianchi_features where artist_id = '4b8eb68442432c242e9242be040bacf9' and ds = '20150518';
delete from mars_tianchi_features where artist_id = '4ee3f9c90101073c99d5440b41f07daa' and ds = '20150614';
delete from mars_tianchi_features where artist_id = '4ee3f9c90101073c99d5440b41f07daa' and ds = '20150622';
delete from mars_tianchi_features where artist_id = '53dd7de874e0999634c28cdd94d21257' and ds = '20150520';
delete from mars_tianchi_features where artist_id = '5e2ef5473cbbdb335f6d51dc57845437' and ds = '20150622';
delete from mars_tianchi_features where artist_id = '6a493121e53d83f9e119b02942d7c8fe' and ds = '20150509';
delete from mars_tianchi_features where artist_id = '6f462b173b2d6d20a2c9fb1ec0fd2dda' and ds = '20150606';
delete from mars_tianchi_features where artist_id = '6f462b173b2d6d20a2c9fb1ec0fd2dda' and ds = '20150607';
delete from mars_tianchi_features where artist_id = '6f462b173b2d6d20a2c9fb1ec0fd2dda' and ds = '20150608';
delete from mars_tianchi_features where artist_id = '82fda1f850a9fe22e41b5c8dadaff4ac' and ds = '20150606';
delete from mars_tianchi_features where artist_id = '8f29cbc2a555034643d66f9e83dd7a7a' and ds = '20150502';
delete from mars_tianchi_features where artist_id = 'b6a175a48743caed6d035444c069ab64' and ds = '20150621';
delete from mars_tianchi_features where artist_id = 'b7522cc91cf57ada15de2298bfd6a3ee' and ds = '20150514';
delete from mars_tianchi_features where artist_id = 'b7522cc91cf57ada15de2298bfd6a3ee' and ds = '20150515';
delete from mars_tianchi_features where artist_id = 'be0c7a23c2aa9afb45163995b9ec938c' and ds = '20150608';
delete from mars_tianchi_features where artist_id = 'bf21d16799b240d6e445fa30472bd50b' and ds = '20150509';
delete from mars_tianchi_features where artist_id = 'c026b84e8f23a7741d9b670e3d8973f0' and ds = '20150508';
delete from mars_tianchi_features where artist_id = 'c5eac1d455675dfbc99f6c70f7b3971f' and ds = '20150608';
delete from mars_tianchi_features where artist_id = 'ca6db6d4f02b7b946c57fc389e67dd7e' and ds = '20150619';
delete from mars_tianchi_features where artist_id = 'e087f8842fe66efa5ccee42ff791e0ca' and ds = '20150630';
delete from mars_tianchi_features where artist_id = 'f6e0f05fde7637afb8f8bc6bda74ca24' and ds = '20150615';
delete from mars_tianchi_features where artist_id = 'f6e0f05fde7637afb8f8bc6bda74ca24' and ds = '20150617';
delete from mars_tianchi_features where artist_id = 'ffd47cf9cb66d226575336f0fa42ae25' and ds = '20150521';*/


