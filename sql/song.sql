--song actions
drop table if exists mars_tianchi_song_actions;
create table mars_tianchi_song_actions
(
artist_id char(32),
song_id char(32),
ds char(8),
action_type char(1),
n int,
primary key(song_id, ds, action_type)
);
drop index mars_tianchi_song_actions_idx on mars_tianchi_song_actions;
create index mars_tianchi_song_actions_idx on mars_tianchi_song_actions(artist_id);
insert into mars_tianchi_song_actions select mars_tianchi_songs.artist_id, mars_tianchi_songs.song_id, mars_tianchi_user_actions.ds, mars_tianchi_user_actions.action_type, count(*) as n from mars_tianchi_songs, mars_tianchi_user_actions where mars_tianchi_songs.song_id = mars_tianchi_user_actions.song_id group by mars_tianchi_songs.artist_id, mars_tianchi_songs.song_id, mars_tianchi_user_actions.ds, mars_tianchi_user_actions.action_type;
-----------------------------------------------
--song user actions
drop table if exists mars_tianchi_song_user_actions;
create table mars_tianchi_song_user_actions
(
artist_id char(32),
song_id char(32),
user_id char(32),
ds char(8),
action_type char(1),
n int,
primary key(song_id, user_id, ds, action_type)
);
drop index mars_tianchi_song_user_actions_idx on mars_tianchi_song_user_actions;
create index mars_tianchi_song_user_actions_idx on mars_tianchi_song_user_actions(artist_id);
insert into mars_tianchi_song_user_actions select mars_tianchi_songs.artist_id, mars_tianchi_songs.song_id, mars_tianchi_user_actions.user_id, mars_tianchi_user_actions.ds, mars_tianchi_user_actions.action_type, count(*) as n from mars_tianchi_songs, mars_tianchi_user_actions where mars_tianchi_songs.song_id = mars_tianchi_user_actions.song_id group by mars_tianchi_songs.artist_id, mars_tianchi_songs.song_id, mars_tianchi_user_actions.user_id, mars_tianchi_user_actions.ds, mars_tianchi_user_actions.action_type;
-----------------------------------------------




