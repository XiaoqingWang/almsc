drop table if exists mars_tianchi_series;
create table mars_tianchi_series
(
artist_id char(32),
ds char(8),
name varchar(256),
val float,
primary key(artist_id, ds, name)
);
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_plays' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series left join mars_tianchi_artist_actions on mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds and mars_tianchi_artist_actions.action_type = '1' set mars_tianchi_series.val = ifnull(mars_tianchi_artist_actions.n, 0) where mars_tianchi_series.name = 's_plays';
--select * from mars_tianchi_series where name = 's_new_plays_div_plays'
--select distinct name from mars_tianchi_series where val is null
--delete from mars_tianchi_series where name = 's_downloads_div_plays_last_7_days'
-----------------------------------------------
delete from mars_tianchi_series where name = 's_avg_plays_last_3_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_avg_plays_last_3_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 0 and 2), 0.0) where mars_tianchi_series.name = 's_avg_plays_last_3_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_avg_plays_last_5_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_avg_plays_last_5_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 0 and 4), 0.0) where mars_tianchi_series.name = 's_avg_plays_last_5_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_avg_plays_last_7_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_avg_plays_last_7_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 0 and 6), 0.0) where mars_tianchi_series.name = 's_avg_plays_last_7_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_downloads';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_downloads' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series left join mars_tianchi_artist_actions on mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds and mars_tianchi_artist_actions.action_type = '2' set mars_tianchi_series.val = ifnull(mars_tianchi_artist_actions.n, 0) where mars_tianchi_series.name = 's_downloads';
----------------------------------------------
delete from mars_tianchi_series where name = 's_avg_downloads_last_3_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_avg_downloads_last_3_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '2' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 0 and 2), 0.0) where mars_tianchi_series.name = 's_avg_downloads_last_3_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_avg_downloads_last_5_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_avg_downloads_last_5_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '2' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 0 and 4), 0.0) where mars_tianchi_series.name = 's_avg_downloads_last_5_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_avg_downloads_last_7_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_avg_downloads_last_7_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '2' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 0 and 6), 0.0) where mars_tianchi_series.name = 's_avg_downloads_last_7_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_collects';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_collects' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series left join mars_tianchi_artist_actions on mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds and mars_tianchi_artist_actions.action_type = '3' set mars_tianchi_series.val = ifnull(mars_tianchi_artist_actions.n, 0) where mars_tianchi_series.name = 's_collects';
----------------------------------------------
delete from mars_tianchi_series where name = 's_avg_collects_last_3_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_avg_collects_last_3_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '3' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 0 and 2), 0.0) where mars_tianchi_series.name = 's_avg_collects_last_3_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_avg_collects_last_5_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_avg_collects_last_5_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '3' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 0 and 4), 0.0) where mars_tianchi_series.name = 's_avg_collects_last_5_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_avg_collects_last_7_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_avg_collects_last_7_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '3' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 0 and 6), 0.0) where mars_tianchi_series.name = 's_avg_collects_last_7_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_diff_plays';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_diff_plays' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) - ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) = 1), 0) where mars_tianchi_series.name = 's_diff_plays';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_diff_downloads';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_diff_downloads' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '2' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) - ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '2' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) = 1), 0) where mars_tianchi_series.name = 's_diff_downloads';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_diff_collects';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_diff_collects' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '3' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) - ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '3' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) = 1), 0) where mars_tianchi_series.name = 's_diff_collects';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_plays_div_plays_prev_1_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_plays_div_plays_prev_1_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) / (ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) = 1), 0) + 1) where mars_tianchi_series.name = 's_plays_div_plays_prev_1_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_plays_div_plays_prev_2_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_plays_div_plays_prev_2_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) / (ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 1 and 2), 0) + 1) where mars_tianchi_series.name = 's_plays_div_plays_prev_2_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_plays_div_plays_prev_4_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_plays_div_plays_prev_4_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) / (ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 1 and 4), 0) + 1) where mars_tianchi_series.name = 's_plays_div_plays_prev_4_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_plays_div_plays_prev_6_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_plays_div_plays_prev_6_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) / (ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 1 and 6), 0) + 1) where mars_tianchi_series.name = 's_plays_div_plays_prev_6_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_plays_div_downloads';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_plays_div_downloads' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) / (ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '2' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) + 1) where mars_tianchi_series.name = 's_plays_div_downloads';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_plays_div_downloads_last_3_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_plays_div_downloads_last_3_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) / (ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '2' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 0 and 2), 0) + 1) where mars_tianchi_series.name = 's_plays_div_downloads_last_3_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_plays_div_downloads_last_5_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_plays_div_downloads_last_5_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) / (ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '2' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 0 and 4), 0) + 1) where mars_tianchi_series.name = 's_plays_div_downloads_last_5_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_plays_div_downloads_last_7_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_plays_div_downloads_last_7_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) / (ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '2' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 0 and 6), 0) + 1) where mars_tianchi_series.name = 's_plays_div_downloads_last_7_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_plays_div_collects';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_plays_div_collects' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) / (ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '3' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) + 1) where mars_tianchi_series.name = 's_plays_div_collects';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_plays_div_collects_last_3_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_plays_div_collects_last_3_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) / (ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '3' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 0 and 2), 0) + 1) where mars_tianchi_series.name = 's_plays_div_collects_last_3_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_plays_div_collects_last_5_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_plays_div_collects_last_5_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) / (ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '3' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 0 and 4), 0) + 1) where mars_tianchi_series.name = 's_plays_div_collects_last_5_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_plays_div_collects_last_7_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_plays_div_collects_last_7_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds), 0) / (ifnull((select avg(n) from mars_tianchi_artist_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_artist_actions.action_type = '3' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 0 and 6), 0) + 1) where mars_tianchi_series.name = 's_plays_div_collects_last_7_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_play_users';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_play_users' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series left join mars_tianchi_artist_users on mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_series.ds = mars_tianchi_artist_users.ds and mars_tianchi_artist_users.action_type = '1' set mars_tianchi_series.val = ifnull(mars_tianchi_artist_users.n, 0) where mars_tianchi_series.name = 's_play_users';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_avg_play_users_last_3_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_avg_play_users_last_3_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_users where mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_artist_users.action_type = '1' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_users.ds) between 0 and 2), 0.0) where mars_tianchi_series.name = 's_avg_play_users_last_3_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_avg_play_users_last_5_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_avg_play_users_last_5_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_users where mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_artist_users.action_type = '1' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_users.ds) between 0 and 4), 0.0) where mars_tianchi_series.name = 's_avg_play_users_last_5_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_avg_play_users_last_7_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_avg_play_users_last_7_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_users where mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_artist_users.action_type = '1' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_users.ds) between 0 and 6), 0.0) where mars_tianchi_series.name = 's_avg_play_users_last_7_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_new_users';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_new_users' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select sum(n) from mars_tianchi_artist_new_users where mars_tianchi_artist_new_users.artist_id = mars_tianchi_series.artist_id and mars_tianchi_artist_new_users.ds = mars_tianchi_series.ds), 0) where mars_tianchi_series.name = 's_new_users';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_users';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_users' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select sum(n) from mars_tianchi_artist_users where mars_tianchi_artist_users.artist_id = mars_tianchi_series.artist_id and mars_tianchi_artist_users.ds = mars_tianchi_series.ds), 0) where mars_tianchi_series.name = 's_users';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_new_users_div_users';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_new_users_div_users' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select sum(n) from mars_tianchi_artist_new_users where mars_tianchi_artist_new_users.artist_id = mars_tianchi_series.artist_id and mars_tianchi_artist_new_users.ds = mars_tianchi_series.ds), 0) / (ifnull((select sum(n) from mars_tianchi_artist_users where mars_tianchi_artist_users.artist_id = mars_tianchi_series.artist_id and mars_tianchi_artist_users.ds = mars_tianchi_series.ds), 0) + 1) where mars_tianchi_series.name = 's_new_users_div_users';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_diff_users';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_diff_users' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select sum(n) from mars_tianchi_artist_users where mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_series.ds = mars_tianchi_artist_users.ds), 0) - ifnull((select sum(n) from mars_tianchi_artist_users where mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and datediff(mars_tianchi_series.ds, mars_tianchi_artist_users.ds) = 1), 0) where mars_tianchi_series.name = 's_diff_users';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_new_plays';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_new_plays' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_new_actions where mars_tianchi_artist_new_actions.action_type = '1' and mars_tianchi_artist_new_actions.artist_id = mars_tianchi_series.artist_id and mars_tianchi_artist_new_actions.ds = mars_tianchi_series.ds), 0) where mars_tianchi_series.name = 's_new_plays';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_new_plays_div_plays';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_new_plays_div_plays' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_new_actions where mars_tianchi_artist_new_actions.action_type = '1' and mars_tianchi_artist_new_actions.artist_id = mars_tianchi_series.artist_id and mars_tianchi_artist_new_actions.ds = mars_tianchi_series.ds), 0) / (ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_artist_actions.action_type = '1' and mars_tianchi_artist_actions.artist_id = mars_tianchi_series.artist_id and mars_tianchi_artist_actions.ds = mars_tianchi_series.ds), 0) + 1) where mars_tianchi_series.name = 's_new_plays_div_plays';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_download_users';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_download_users' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series left join mars_tianchi_artist_users on mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_series.ds = mars_tianchi_artist_users.ds and mars_tianchi_artist_users.action_type = '2' set mars_tianchi_series.val = ifnull(mars_tianchi_artist_users.n, 0) where mars_tianchi_series.name = 's_download_users';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_avg_download_users_last_3_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_avg_download_users_last_3_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_users where mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_artist_users.action_type = '2' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_users.ds) between 0 and 2), 0.0) where mars_tianchi_series.name = 's_avg_download_users_last_3_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_avg_download_users_last_5_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_avg_download_users_last_5_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_users where mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_artist_users.action_type = '2' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_users.ds) between 0 and 4), 0.0) where mars_tianchi_series.name = 's_avg_download_users_last_5_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_avg_download_users_last_7_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_avg_download_users_last_7_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_users where mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_artist_users.action_type = '2' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_users.ds) between 0 and 6), 0.0) where mars_tianchi_series.name = 's_avg_download_users_last_7_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_collect_users';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_collect_users' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series left join mars_tianchi_artist_users on mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_series.ds = mars_tianchi_artist_users.ds and mars_tianchi_artist_users.action_type = '3' set mars_tianchi_series.val = ifnull(mars_tianchi_artist_users.n, 0) where mars_tianchi_series.name = 's_collect_users';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_avg_collect_users_last_3_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_avg_collect_users_last_3_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_users where mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_artist_users.action_type = '3' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_users.ds) between 0 and 2), 0.0) where mars_tianchi_series.name = 's_avg_collect_users_last_3_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_avg_collect_users_last_5_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_avg_collect_users_last_5_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_users where mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_artist_users.action_type = '3' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_users.ds) between 0 and 4), 0.0) where mars_tianchi_series.name = 's_avg_collect_users_last_5_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_avg_collect_users_last_7_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_avg_collect_users_last_7_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_users where mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_artist_users.action_type = '3' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_users.ds) between 0 and 6), 0.0) where mars_tianchi_series.name = 's_avg_collect_users_last_7_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_download_users_div_play_users';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_download_users_div_play_users' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_users where mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_artist_users.action_type = '2' and mars_tianchi_series.ds =  mars_tianchi_artist_users.ds), 0.0) / (ifnull((select n from mars_tianchi_artist_users where mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_artist_users.action_type = '1' and mars_tianchi_series.ds =  mars_tianchi_artist_users.ds), 0.0) + 1) where mars_tianchi_series.name = 's_download_users_div_play_users';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_download_users_div_play_users_last_3_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_download_users_div_play_users_last_3_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_users where mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_artist_users.action_type = '2' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_users.ds) between 0 and 2), 0.0) / (ifnull((select avg(n) from mars_tianchi_artist_users where mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_artist_users.action_type = '1' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_users.ds) between 0 and 2), 0.0) + 1) where mars_tianchi_series.name = 's_download_users_div_play_users_last_3_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_download_users_div_play_users_last_5_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_download_users_div_play_users_last_5_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_users where mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_artist_users.action_type = '2' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_users.ds) between 0 and 4), 0.0) / (ifnull((select avg(n) from mars_tianchi_artist_users where mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_artist_users.action_type = '1' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_users.ds) between 0 and 4), 0.0) + 1) where mars_tianchi_series.name = 's_download_users_div_play_users_last_5_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_download_users_div_play_users_last_7_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_download_users_div_play_users_last_7_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_users where mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_artist_users.action_type = '2' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_users.ds) between 0 and 6), 0.0) / (ifnull((select avg(n) from mars_tianchi_artist_users where mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_artist_users.action_type = '1' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_users.ds) between 0 and 6), 0.0) + 1) where mars_tianchi_series.name = 's_download_users_div_play_users_last_7_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_collect_users_div_play_users';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_collect_users_div_play_users' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select n from mars_tianchi_artist_users where mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_artist_users.action_type = '3' and mars_tianchi_series.ds =  mars_tianchi_artist_users.ds), 0.0) / (ifnull((select n from mars_tianchi_artist_users where mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_artist_users.action_type = '1' and mars_tianchi_series.ds =  mars_tianchi_artist_users.ds), 0.0) + 1) where mars_tianchi_series.name = 's_collect_users_div_play_users';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_collect_users_div_play_users_last_3_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_collect_users_div_play_users_last_3_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_users where mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_artist_users.action_type = '3' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_users.ds) between 0 and 2), 0.0) / (ifnull((select avg(n) from mars_tianchi_artist_users where mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_artist_users.action_type = '1' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_users.ds) between 0 and 2), 0.0) + 1) where mars_tianchi_series.name = 's_collect_users_div_play_users_last_3_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_collect_users_div_play_users_last_5_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_collect_users_div_play_users_last_5_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_users where mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_artist_users.action_type = '3' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_users.ds) between 0 and 4), 0.0) / (ifnull((select avg(n) from mars_tianchi_artist_users where mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_artist_users.action_type = '1' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_users.ds) between 0 and 4), 0.0) + 1) where mars_tianchi_series.name = 's_collect_users_div_play_users_last_5_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_collect_users_div_play_users_last_7_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_collect_users_div_play_users_last_7_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg(n) from mars_tianchi_artist_users where mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_artist_users.action_type = '3' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_users.ds) between 0 and 6), 0.0) / (ifnull((select avg(n) from mars_tianchi_artist_users where mars_tianchi_series.artist_id = mars_tianchi_artist_users.artist_id and mars_tianchi_artist_users.action_type = '1' and datediff(mars_tianchi_series.ds, mars_tianchi_artist_users.ds) between 0 and 6), 0.0) + 1) where mars_tianchi_series.name = 's_collect_users_div_play_users_last_7_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_cov_user_plays';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_cov_user_plays' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select cov from mars_tianchi_artist_cov_user_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_cov_user_actions.artist_id and mars_tianchi_artist_cov_user_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_cov_user_actions.ds), 0.0) where mars_tianchi_series.name = 's_cov_user_plays';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_work_cov_hour_plays';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_work_cov_hour_plays' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select cov from mars_tianchi_artist_work_cov_hour_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_work_cov_hour_actions.artist_id and mars_tianchi_artist_work_cov_hour_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_work_cov_hour_actions.ds), 0.0) where mars_tianchi_series.name = 's_work_cov_hour_plays';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_rest_cov_hour_plays';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_rest_cov_hour_plays' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select cov from mars_tianchi_artist_rest_cov_hour_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_rest_cov_hour_actions.artist_id and mars_tianchi_artist_rest_cov_hour_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_rest_cov_hour_actions.ds), 0.0) where mars_tianchi_series.name = 's_rest_cov_hour_plays';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_sleep_cov_hour_plays';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_sleep_cov_hour_plays' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select cov from mars_tianchi_artist_sleep_cov_hour_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_sleep_cov_hour_actions.artist_id and mars_tianchi_artist_sleep_cov_hour_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_sleep_cov_hour_actions.ds), 0.0) where mars_tianchi_series.name = 's_sleep_cov_hour_plays';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_work_avg_plays';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_work_avg_plays' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg from mars_tianchi_artist_work_cov_hour_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_work_cov_hour_actions.artist_id and mars_tianchi_artist_work_cov_hour_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_work_cov_hour_actions.ds), 0.0) where mars_tianchi_series.name = 's_work_avg_plays';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_rest_avg_plays';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_rest_avg_plays' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg from mars_tianchi_artist_rest_cov_hour_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_rest_cov_hour_actions.artist_id and mars_tianchi_artist_rest_cov_hour_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_rest_cov_hour_actions.ds), 0.0) where mars_tianchi_series.name = 's_rest_avg_plays';
-----------------------------------------------
delete from mars_tianchi_series where name = 's_sleep_avg_plays';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 's_sleep_avg_plays' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series set mars_tianchi_series.val = ifnull((select avg from mars_tianchi_artist_sleep_cov_hour_actions where mars_tianchi_series.artist_id = mars_tianchi_artist_sleep_cov_hour_actions.artist_id and mars_tianchi_artist_sleep_cov_hour_actions.action_type = '1' and mars_tianchi_series.ds = mars_tianchi_artist_sleep_cov_hour_actions.ds), 0.0) where mars_tianchi_series.name = 's_sleep_avg_plays';



