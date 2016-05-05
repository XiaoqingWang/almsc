--song actions
drop table if exists mars_tianchi_song_actions;
create table mars_tianchi_song_actions
(
song_id char(32),
ds char(8),
action_type char(1),
n int,
primary key(song_id, ds, action_type)
);
insert into mars_tianchi_song_actions 
select song_id, ds, action_type, count(*) as n from mars_tianchi_user_actions
group by song_id, ds, action_type;
insert ignore into mars_tianchi_song_actions
--fill with 0
select mars_tianchi_songs.song_id, mars_tianchi_ds.ds, '1' as action_type, 0 as n 
from mars_tianchi_songs, mars_tianchi_ds;
insert ignore into mars_tianchi_song_actions
select mars_tianchi_songs.song_id, mars_tianchi_ds.ds, '2' as action_type, 0 as n 
from mars_tianchi_songs, mars_tianchi_ds;
insert ignore into mars_tianchi_song_actions
select mars_tianchi_songs.song_id, mars_tianchi_ds.ds, '3' as action_type, 0 as n 
from mars_tianchi_songs, mars_tianchi_ds;

--artist actions
drop table if exists mars_tianchi_artist_actions;
create table mars_tianchi_artist_actions
(
artist_id char(32),
ds char(8),
action_type char(1),
n int,
primary key(artist_id, ds, action_type)
);
insert into mars_tianchi_artist_actions 
select mars_tianchi_songs.artist_id, mars_tianchi_song_actions.ds, mars_tianchi_song_actions.action_type, count(*) as n from mars_tianchi_songs, mars_tianchi_song_actions
where mars_tianchi_songs.song_id = mars_tianchi_song_actions.song_id
group by mars_tianchi_songs.artist_id, mars_tianchi_song_actions.ds, mars_tianchi_song_actions.action_type;
--fill with 0
insert ignore into mars_tianchi_artist_actions
select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, '1' as action_type, 0 as n 
from mars_tianchi_artists, mars_tianchi_ds;
insert ignore into mars_tianchi_artist_actions
select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, '2' as action_type, 0 as n 
from mars_tianchi_artists, mars_tianchi_ds;
insert ignore into mars_tianchi_artist_actions
select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, '3' as action_type, 0 as n 
from mars_tianchi_artists, mars_tianchi_ds;