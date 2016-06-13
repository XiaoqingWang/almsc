--result record
drop table if exists mars_tianchi_artist_plays_predict;
create table mars_tianchi_artist_plays_predict
(
record_id char(10),
artist_id char(32),
ds char(8),
plays int,
primary key(record_id, artist_id, ds)
);