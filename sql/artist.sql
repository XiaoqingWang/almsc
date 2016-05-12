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
insert into mars_tianchi_song_actions 
select mars_tianchi_songs.artist_id, mars_tianchi_songs.song_id, mars_tianchi_user_actions.ds, mars_tianchi_user_actions.action_type, count(*) as n from mars_tianchi_songs, mars_tianchi_user_actions
where mars_tianchi_songs.song_id = mars_tianchi_user_actions.song_id
group by mars_tianchi_songs.artist_id, mars_tianchi_songs.song_id, mars_tianchi_user_actions.ds, mars_tianchi_user_actions.action_type;

--all artists
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
set @artist_code:=0;
insert into mars_tianchi_artists(artist_id, artist_code)
select artist_id, @artist_code:=@artist_code+1 from (
select distinct(artist_id) from mars_tianchi_songs) t;

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
select mars_tianchi_song_actions.artist_id, mars_tianchi_song_actions.ds, mars_tianchi_song_actions.action_type, sum(n) as n from mars_tianchi_song_actions
group by mars_tianchi_song_actions.artist_id, mars_tianchi_song_actions.ds, mars_tianchi_song_actions.action_type;
--select max(n) from mars_tianchi_artist_actions

--artist n_songs
update mars_tianchi_artists set
mars_tianchi_artists.n_songs = (select count(*) from mars_tianchi_songs where mars_tianchi_artists.artist_id = mars_tianchi_songs.artist_id);

--artist gender
update mars_tianchi_artists set
gender = (select distinct gender from mars_tianchi_songs where mars_tianchi_artists.artist_id = mars_tianchi_songs.artist_id);

--artist language
update mars_tianchi_artists set
mars_tianchi_artists.n_languages = (select count(distinct language) from mars_tianchi_songs where mars_tianchi_artists.artist_id = mars_tianchi_songs.artist_id);
drop table if exists mars_tianchi_artist_languages;
create table mars_tianchi_artist_languages
(
artist_id char(32),
language int,
n int,
primary key(artist_id, n)
);
insert into mars_tianchi_artist_languages select artist_id, language, count(*) from mars_tianchi_songs group by artist_id, language;
update mars_tianchi_artists set
mars_tianchi_artists.mode_language = (select language from mars_tianchi_artist_languages where mars_tianchi_artist_languages.artist_id = mars_tianchi_artists.artist_id order by mars_tianchi_artist_languages.n desc limit 1);

--artist week actions
drop table if exists mars_tianchi_artist_week_actions;
create table mars_tianchi_artist_week_actions
(
artist_id char(32),
week int,
action_type char(1),
sum_n int,
max_n int,
min_n int,
avg_n float,
std_n float,
primary key(artist_id, week, action_type)
);
insert into mars_tianchi_artist_week_actions 
select artist_id, week(ds, 0) as week, action_type, sum(n), max(n), min(n), avg(n), std(n) from mars_tianchi_artist_actions group by artist_id, week, action_type;

--artist month weekday actions
drop table if exists mars_tianchi_artist_month_weekday_actions;
create table mars_tianchi_artist_month_weekday_actions
(
artist_id char(32),
month int,
weekday int,
action_type char(1),
sum_n int,
max_n int,
min_n int,
avg_n float,
std_n float,
primary key(artist_id, month, weekday, action_type)
);
insert into mars_tianchi_artist_month_weekday_actions 
select artist_id, month(ds) as month, dayofweek(ds) as weekday, action_type, sum(n), max(n), min(n), avg(n), std(n) from mars_tianchi_artist_actions group by artist_id, month, weekday, action_type;

--artist month song actions
drop table if exists mars_tianchi_artist_month_song_actions;
create table mars_tianchi_artist_month_song_actions
(
artist_id char(32),
month int,
action_type char(1),
sum_n int,
max_n int,
min_n int,
avg_n float,
std_n float,
primary key(artist_id, month, action_type)
);
insert into mars_tianchi_artist_month_song_actions 
select artist_id, month(ds) as month, action_type, sum(n), max(n), min(n), avg(n), std(n) from mars_tianchi_song_actions group by artist_id, month, action_type;

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
insert into mars_tianchi_song_user_actions 
select mars_tianchi_songs.artist_id, mars_tianchi_songs.song_id, mars_tianchi_user_actions.user_id, mars_tianchi_user_actions.ds, mars_tianchi_user_actions.action_type, count(*) as n from mars_tianchi_songs, mars_tianchi_user_actions
where mars_tianchi_songs.song_id = mars_tianchi_user_actions.song_id
group by mars_tianchi_songs.artist_id, mars_tianchi_songs.song_id, mars_tianchi_user_actions.user_id, mars_tianchi_user_actions.ds, mars_tianchi_user_actions.action_type;

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
insert into mars_tianchi_artist_user_actions 
select mars_tianchi_song_user_actions.artist_id, mars_tianchi_song_user_actions.user_id, mars_tianchi_song_user_actions.ds, mars_tianchi_song_user_actions.action_type, sum(n) as n from mars_tianchi_song_user_actions
group by mars_tianchi_song_user_actions.artist_id, mars_tianchi_song_user_actions.user_id, mars_tianchi_song_user_actions.ds, mars_tianchi_song_user_actions.action_type;

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
insert into mars_tianchi_artist_users 
select artist_id, ds, action_type, count(*) from mars_tianchi_artist_user_actions
group by artist_id, ds, action_type
--select max(n) from mars_tianchi_artist_users
