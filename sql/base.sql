--all days
drop table if exists mars_tianchi_ds;
create table mars_tianchi_ds
(
ds char(8),
year int,
month int,
day int,
season int,
weekday int,
primary key(ds)
);
--offline
insert into mars_tianchi_ds(ds)
select distinct ds from mars_tianchi_user_actions
order by ds;
--oneline
set @online_begin:='20150831';
insert into mars_tianchi_ds(ds)
select @online_begin:=DATE_FORMAT(ADDDATE(@online_begin, 1), '%Y%m%d')
from mars_tianchi_ds limit 60

--details
update mars_tianchi_ds set 
year = year(ds),
month = month(ds),
day = dayofmonth(ds),
season = (case month when 3 then 1 when 4 then 1 when 5 then 1 
                     when 6 then 2 when 7 then 2 when 8 then 2
                     when 9 then 3 when 10 then 3 when 11 then 3
                     when 12 then 4 when 1 then 4 when 2 then 4
                     else 0 end),
weekday = weekday(ds);              

--all artists
drop table if exists mars_tianchi_artists;
create table mars_tianchi_artists
(
artist_id char(32),
primary key(artist_id)
);
insert into mars_tianchi_artists
select distinct(artist_id) as artist_id from mars_tianchi_songs;