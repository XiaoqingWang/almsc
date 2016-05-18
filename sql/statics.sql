set @begin_X_train:=(select min(ds) from mars_tianchi_samples where is_X = 1 and is_train = 1);
set @end_X_train:=(select max(ds) from mars_tianchi_samples where is_X = 1 and is_train = 1);
set @begin_y_train:=(select min(ds) from mars_tianchi_samples where is_X = 0 and is_train = 1);
set @end_y_train:=(select max(ds) from mars_tianchi_samples where is_X = 0 and is_train = 1);
set @begin_X_test:=(select min(ds) from mars_tianchi_samples where is_X = 1 and is_train = 0);
set @end_X_test:=(select max(ds) from mars_tianchi_samples where is_X = 1 and is_train = 0);
set @begin_y_test:=(select min(ds) from mars_tianchi_samples where is_X = 0 and is_train = 0);
set @end_y_test:=(select max(ds) from mars_tianchi_samples where is_X = 0 and is_train = 0);
--mid
drop table if exists mars_tianchi_samples_artist_plays_midean;
create table mars_tianchi_samples_artist_plays_midean
(
artist_id char(32),
is_X int, -- 1:X,0:y
is_train int, --1:train,0:test
mid_plays float,
primary key(artist_id, is_X, is_train)
);
insert into mars_tianchi_samples_artist_plays_midean select artist_id, is_X, is_train, avg(plays) from ( select e.artist_id, e.is_X, e.is_train, e.plays from mars_tianchi_samples e, mars_tianchi_samples d where e.artist_id = d.artist_id and e.is_X = d.is_X and e.is_train = d.is_train group by e.artist_id, e.is_X, e.is_train, e.plays having sum(case when e.plays = d.plays then 1 else 0 end)>= abs(sum(sign(e.plays - d.plays))))t group by artist_id, is_X, is_train;