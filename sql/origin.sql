--origin file:mars_tianchi_user_actions
drop table if exists mars_tianchi_user_actions;
create table mars_tianchi_user_actions
(
user_id char(32),
song_id char(32),
gmt_create char(10),
action_type char(1),
ds char(8));
create index mars_tianchi_user_actions_idx on mars_tianchi_user_actions (song_id, action_type, ds);
--select count(*) from mars_tianchi_user_actions

--origin file:mars_tianchi_songs
drop table if exists mars_tianchi_songs;
create table mars_tianchi_songs
(
song_id char(32),
artist_id char(32),
publish_time char(8),
song_init_plays int,
language int,
gender char(1),
primary key(song_id, artist_id));
--select * from mars_tianchi_songs
--select count(distinct artist_id) from mars_tianchi_songs