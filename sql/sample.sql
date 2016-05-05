--sample
drop table if exists mars_tianchi_features;
create table mars_tianchi_features
(
artist_id char(32),
ds char(8),
plays int,
primary key(artist_id, ds)
);
insert into mars_tianchi_features(artist_id, ds, plays)
select artist_id, ds, n as plays from mars_tianchi_artist_actions
where action_type = '1' and month(ds);