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
update mars_tianchi_series left join mars_tianchi_artist_actions on mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds and mars_tianchi_artist_actions.action_type = '1' set mars_tianchi_series.val = mars_tianchi_artist_actions.n where mars_tianchi_series.name = 'plays';collects
--select * from mars_tianchi_series where name = 'diff_plays'
-----------------------------------------------
drop table if exists mars_tianchi_feature_definations;
create table mars_tianchi_feature_definations
(
artist_id char(32),
name varchar(256),
is_category int, --1:category,0:not
i_series int,
offset int,
correlation float,
primary key(artist_id, name, i_series)
);
--select * from mars_tianchi_feature_definations where name = 'plays'
-----------------------------------------------
delete from mars_tianchi_series where name = 'avg_plays_last_7_days';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'avg_plays_last_7_days' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series 
set mars_tianchi_series.val = 
(select avg(n) from mars_tianchi_artist_actions where
mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id 
and mars_tianchi_artist_actions.action_type = '1' 
and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) between 0 and 6)
where mars_tianchi_series.name = 'avg_plays_last_7_days';
-----------------------------------------------
delete from mars_tianchi_series where name = 'diff_plays';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'diff_plays' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series 
set mars_tianchi_series.val = 
(select n from mars_tianchi_artist_actions where
mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id 
and mars_tianchi_artist_actions.action_type = '1' 
and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds)
-
ifnull((select n from mars_tianchi_artist_actions where
mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id 
and mars_tianchi_artist_actions.action_type = '1' 
and datediff(mars_tianchi_series.ds, mars_tianchi_artist_actions.ds) = 1), 0)
where mars_tianchi_series.name = 'diff_plays';
----------------------------------------------
delete from mars_tianchi_series where name = 'collects';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'collects' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series left join mars_tianchi_artist_actions on mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds and mars_tianchi_artist_actions.action_type = '3' set mars_tianchi_series.val = ifnull(mars_tianchi_artist_actions.n, 0) where mars_tianchi_series.name = 'collects';
----------------------------------------------
delete from mars_tianchi_series where name = 'downloads';
insert into mars_tianchi_series(artist_id, ds, name) select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, 'downloads' as name from mars_tianchi_artists, mars_tianchi_ds;
update mars_tianchi_series left join mars_tianchi_artist_actions on mars_tianchi_series.artist_id = mars_tianchi_artist_actions.artist_id and mars_tianchi_series.ds = mars_tianchi_artist_actions.ds and mars_tianchi_artist_actions.action_type = '2' set mars_tianchi_series.val = ifnull(mars_tianchi_artist_actions.n, 0) where mars_tianchi_series.name = 'downloads';
----------------------------------------------
