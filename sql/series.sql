drop table if exists mars_tianchi_series;
create table mars_tianchi_series
(
artist_id char(32),
ds char(8),
name varchar(256),
val float,
primary key(artist_id, ds, name)
);
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'plays' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series left join mars_tianchi_artist_actions on mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds and mars_tianchi_artist_actions.action_type = '1' set mars_tianchi_series.val = mars_tianchi_artist_actions.n where mars_tianchi_series.name = 'plays';
--select * from mars_tianchi_series where name = 'play_users'
--select distinct name from mars_tianchi_series where val is null
--delete from mars_tianchi_series where name = 'downloads_div_plays_last_7_days'
-----------------------------------------------
delete from mars_tianchi_series where name = 'avg_plays_last_3_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'avg_plays_last_3_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 0 and 2), 0.0) where mars_tianchi_series.name = 'avg_plays_last_3_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 'avg_plays_last_5_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'avg_plays_last_5_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 0 and 4), 0.0) where mars_tianchi_series.name = 'avg_plays_last_5_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 'avg_plays_last_7_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'avg_plays_last_7_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 0 and 6), 0.0) where mars_tianchi_series.name = 'avg_plays_last_7_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 'downloads';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'downloads' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series left join mars_tianchi_artist_actions on mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds and mars_tianchi_artist_actions.action_type = '2' set mars_tianchi_series.val = ifnull(mars_tianchi_artist_actions.n, 0) where mars_tianchi_series.name = 'downloads';
----------------------------------------------
delete from mars_tianchi_series where name = 'avg_downloads_last_3_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'avg_downloads_last_3_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '2' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 0 and 2), 0.0) where mars_tianchi_series.name = 'avg_downloads_last_3_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 'avg_downloads_last_5_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'avg_downloads_last_5_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '2' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 0 and 4), 0.0) where mars_tianchi_series.name = 'avg_downloads_last_5_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 'avg_downloads_last_7_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'avg_downloads_last_7_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '2' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 0 and 6), 0.0) where mars_tianchi_series.name = 'avg_downloads_last_7_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 'collects';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'collects' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series left join mars_tianchi_artist_actions on mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds and mars_tianchi_artist_actions.action_type = '3' set mars_tianchi_series.val = ifnull(mars_tianchi_artist_actions.n, 0) where mars_tianchi_series.name = 'collects';
----------------------------------------------
delete from mars_tianchi_series where name = 'avg_collects_last_3_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'avg_collects_last_3_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '3' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 0 and 2), 0.0) where mars_tianchi_series.name = 'avg_collects_last_3_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 'avg_collects_last_5_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'avg_collects_last_5_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '3' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 0 and 4), 0.0) where mars_tianchi_series.name = 'avg_collects_last_5_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 'avg_collects_last_7_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'avg_collects_last_7_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '3' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 0 and 6), 0.0) where mars_tianchi_series.name = 'avg_collects_last_7_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 'diff_plays';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'diff_plays' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) - ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) = 1), 0) where mars_tianchi_series.name = 'diff_plays';
-----------------------------------------------
delete from mars_tianchi_series where name = 'diff_downloads';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'diff_downloads' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '2' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) - ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '2' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) = 1), 0) where mars_tianchi_series.name = 'diff_downloads';
-----------------------------------------------
delete from mars_tianchi_series where name = 'diff_collects';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'diff_collects' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '3' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) - ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '3' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) = 1), 0) where mars_tianchi_series.name = 'diff_collects';
-----------------------------------------------
delete from mars_tianchi_series where name = 'plays_div_plays_prev_1_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'plays_div_plays_prev_1_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) / (ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) = 1), 0) + 1) where mars_tianchi_series.name = 'plays_div_plays_prev_1_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 'plays_div_plays_prev_2_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'plays_div_plays_prev_2_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) / (ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 1 and 2), 0) + 1) where mars_tianchi_series.name = 'plays_div_plays_prev_2_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 'plays_div_plays_prev_4_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'plays_div_plays_prev_4_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) / (ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 1 and 4), 0) + 1) where mars_tianchi_series.name = 'plays_div_plays_prev_4_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 'plays_div_plays_prev_6_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'plays_div_plays_prev_6_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) / (ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 1 and 6), 0) + 1) where mars_tianchi_series.name = 'plays_div_plays_prev_6_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 'plays_div_downloads';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'plays_div_downloads' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) / (ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '2' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) + 1) where mars_tianchi_series.name = 'plays_div_downloads';
-----------------------------------------------
delete from mars_tianchi_series where name = 'plays_div_downloads_last_3_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'plays_div_downloads_last_3_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) / (ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '2' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 0 and 2), 0) + 1) where mars_tianchi_series.name = 'plays_div_downloads_last_3_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 'plays_div_downloads_last_5_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'plays_div_downloads_last_5_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) / (ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '2' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 0 and 4), 0) + 1) where mars_tianchi_series.name = 'plays_div_downloads_last_5_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 'plays_div_downloads_last_7_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'plays_div_downloads_last_7_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) / (ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '2' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 0 and 6), 0) + 1) where mars_tianchi_series.name = 'plays_div_downloads_last_7_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 'plays_div_collects';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'plays_div_collects' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) / (ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '3' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) + 1) where mars_tianchi_series.name = 'plays_div_collects';
-----------------------------------------------
delete from mars_tianchi_series where name = 'plays_div_collects_last_3_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'plays_div_collects_last_3_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) / (ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '3' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 0 and 2), 0) + 1) where mars_tianchi_series.name = 'plays_div_collects_last_3_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 'plays_div_collects_last_5_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'plays_div_collects_last_5_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) / (ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '3' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 0 and 4), 0) + 1) where mars_tianchi_series.name = 'plays_div_collects_last_5_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 'plays_div_collects_last_7_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'plays_div_collects_last_7_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) / (ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '3' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 0 and 6), 0) + 1) where mars_tianchi_series.name = 'plays_div_collects_last_7_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 'play_users';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'play_users' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series left join mars_tianchi_artist_users on mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_series.ds = mars_tianchi_artist_users.ds and mars_tianchi_artist_users.action_type = '1' set mars_tianchi_series.val = ifnull(mars_tianchi_artist_users.n, 0) where mars_tianchi_series.name = 'play_users';
-----------------------------------------------
delete from mars_tianchi_series where name = 'avg_play_users_last_3_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'avg_play_users_last_3_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_users where mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_artist_users.action_type = '1' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_users.ds) between 0 and 2), 0.0) where mars_tianchi_series.name = 'avg_play_users_last_3_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 'avg_play_users_last_5_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'avg_play_users_last_5_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_users where mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_artist_users.action_type = '1' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_users.ds) between 0 and 4), 0.0) where mars_tianchi_series.name = 'avg_play_users_last_5_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 'avg_play_users_last_7_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'avg_play_users_last_7_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_users where mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_artist_users.action_type = '1' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_users.ds) between 0 and 6), 0.0) where mars_tianchi_series.name = 'avg_play_users_last_7_days';




