--artists
set @artist_code:=0;
drop table if exists mars_tianchi_artists;
create table mars_tianchi_artists
(
artist_id char(32),
artist_code int,
n_songs int,
gender char(1),
n_languages int,
mode_language int,
primary key(artist_id)
);
insert into mars_tianchi_artists(artist_id, artist_code) select artist_id, @artist_code:=@artist_code+1 from ( select distinct(artist_id) from mars_tianchi_songs) t;
--artist songs
update mars_tianchi_artists set mars_tianchi_artists.n_songs = (select count(*) from mars_tianchi_songs where mars_tianchi_artists.artist_id = mars_tianchi_songs.artist_id);
--artist gender
update mars_tianchi_artists set gender = (select distinct gender from mars_tianchi_songs where mars_tianchi_artists.artist_id = mars_tianchi_songs.artist_id);
--artist language
update mars_tianchi_artists set mars_tianchi_artists.n_languages = (select count(distinct language) from mars_tianchi_songs where mars_tianchi_artists.artist_id = mars_tianchi_songs.artist_id); drop table if exists mars_tianchi_artist_languages;
create table mars_tianchi_artist_languages
(
artist_id char(32),
language int,
n int,
primary key(artist_id, n)
);
insert into mars_tianchi_artist_languages select artist_id, language, count(*) from mars_tianchi_songs group by artist_id, language;
update mars_tianchi_artists set mars_tianchi_artists.mode_language = (select language from mars_tianchi_artist_languages where mars_tianchi_artist_languages.artist_id = mars_tianchi_artists.artist_id order by mars_tianchi_artist_languages.n desc limit 1);
-----------------------------------------------
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
insert into mars_tianchi_artist_actions select mars_tianchi_song_actions.artist_id, mars_tianchi_song_actions.ds, mars_tianchi_song_actions.action_type, sum(n) as n from mars_tianchi_song_actions group by mars_tianchi_song_actions.artist_id, mars_tianchi_song_actions.ds, mars_tianchi_song_actions.action_type;
--select max(n) from mars_tianchi_artist_actions
-----------------------------------------------
--artist user actions
drop table if exists mars_tianchi_artist_user_actions;
create table mars_tianchi_artist_user_actions
(
artist_id char(32),
user_id char(32),
ds char(8),
action_type char(1),
n int,
primary key(artist_id, user_id, ds, action_type)
);
insert into mars_tianchi_artist_user_actions select mars_tianchi_song_user_actions.artist_id, mars_tianchi_song_user_actions.user_id, mars_tianchi_song_user_actions.ds, mars_tianchi_song_user_actions.action_type, sum(n) as n from mars_tianchi_song_user_actions group by mars_tianchi_song_user_actions.artist_id, mars_tianchi_song_user_actions.user_id, mars_tianchi_song_user_actions.ds, mars_tianchi_song_user_actions.action_type;
--select * from mars_tianchi_artist_user_actions order by artist_id, user_id, ds
-----------------------------------------------
--artist users
drop table if exists mars_tianchi_artist_users;
create table mars_tianchi_artist_users
(
artist_id char(32),
ds char(8),
action_type char(1),
n int,
primary key(artist_id, ds, action_type)
);
insert into mars_tianchi_artist_users select artist_id, ds, action_type, count(*) from mars_tianchi_artist_user_actions group by artist_id, ds, action_type;
--select * from mars_tianchi_artist_users
-----------------------------------------------
--artist new users
drop table if exists mars_tianchi_artist_new_users;
create table mars_tianchi_artist_new_users
(
artist_id char(32),
ds char(8),
action_type char(1),
n int,
primary key(artist_id, ds, action_type)
);
insert into mars_tianchi_artist_new_users select artist_id, ds, action_type, count(*) from mars_tianchi_artist_user_actions t1 where not exists (select 1 from mars_tianchi_artist_user_actions t2 where t2.artist_id = t1.artist_id and t2.action_type = t1.action_type and t2.user_id = t1.user_id and t2.ds < t1.ds) group by artist_id, ds, action_type;
-----------------------------------------------
--artist new actions
drop table if exists mars_tianchi_artist_new_actions;
create table mars_tianchi_artist_new_actions
(
artist_id char(32),
ds char(8),
action_type char(1),
n int,
primary key(artist_id, ds, action_type)
);
insert into mars_tianchi_artist_new_actions select artist_id, ds, action_type, sum(n) from mars_tianchi_song_user_actions t1 where not exists (select 1 from mars_tianchi_song_user_actions t2 where t2.artist_id = t1.artist_id and t2.action_type = t1.action_type and t2.song_id = t1.song_id and t2.user_id = t1.user_id and t2.ds < t1.ds) group by artist_id, ds, action_type;
-----------------------------------------------