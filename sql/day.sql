--all days
drop table if exists mars_tianchi_ds;
create table mars_tianchi_ds
(
ds char(8),
year int,
month int,
day int,
season int,
week int,
weekday int,
is_holiday int,
n_holidays int, 
i_holidays int,
is_good_voice int,
is_music_festival int,
primary key(ds)
);
set @begin:='20150228';
insert into mars_tianchi_ds(ds)
select @begin:=DATE_FORMAT(ADDDATE(@begin, 1), '%Y%m%d')
from mars_tianchi_user_actions limit 244;

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
week = week(ds, 0),
weekday = dayofweek(ds),
is_holiday = (case weekday when 1 then 0 when 2 then 0 when 3 then 0 when 4 then 0 
                        when 5 then 0 when 6 then 1 when 7 then 1 else 0 end),
n_holidays = (case is_holiday when 0 then 0 when 1 then 2 else 0 end),
i_holidays = (case weekday when 6 then 1 when 7 then 2 else 0 end),
is_good_voice = 0,
is_music_festival = 0;

--holiday
update mars_tianchi_ds set is_holiday = 1, n_holidays=3, i_holidays=1 where ds = '20150404';
update mars_tianchi_ds set is_holiday = 1, n_holidays=3, i_holidays=2 where ds = '20150405';
update mars_tianchi_ds set is_holiday = 1, n_holidays=3, i_holidays=3 where ds = '20150406';
update mars_tianchi_ds set is_holiday = 1, n_holidays=3, i_holidays=1 where ds = '20150501';
update mars_tianchi_ds set is_holiday = 1, n_holidays=3, i_holidays=2 where ds = '20150502';
update mars_tianchi_ds set is_holiday = 1, n_holidays=3, i_holidays=3 where ds = '20150503';
update mars_tianchi_ds set is_holiday = 1, n_holidays=3, i_holidays=1 where ds = '20150620';
update mars_tianchi_ds set is_holiday = 1, n_holidays=3, i_holidays=2 where ds = '20150621';
update mars_tianchi_ds set is_holiday = 1, n_holidays=3, i_holidays=3 where ds = '20150622';
update mars_tianchi_ds set is_holiday = 1, n_holidays=2, i_holidays=1 where ds = '20150926';
update mars_tianchi_ds set is_holiday = 1, n_holidays=2, i_holidays=2 where ds = '20150927';
update mars_tianchi_ds set is_holiday = 1, n_holidays=7, i_holidays=1 where ds = '20151001';
update mars_tianchi_ds set is_holiday = 1, n_holidays=7, i_holidays=2 where ds = '20151002';
update mars_tianchi_ds set is_holiday = 1, n_holidays=7, i_holidays=3 where ds = '20151003';
update mars_tianchi_ds set is_holiday = 1, n_holidays=7, i_holidays=4 where ds = '20151004';
update mars_tianchi_ds set is_holiday = 1, n_holidays=7, i_holidays=5 where ds = '20151005';
update mars_tianchi_ds set is_holiday = 1, n_holidays=7, i_holidays=6 where ds = '20151006';
update mars_tianchi_ds set is_holiday = 1, n_holidays=7, i_holidays=7 where ds = '20151007';
update mars_tianchi_ds set is_holiday = 0, n_holidays=0, i_holidays=0 where ds = '20151010';
update mars_tianchi_ds set is_holiday = 1, n_holidays=1, i_holidays=1 where ds = '20151011';

--tv shows
--good voice
update mars_tianchi_ds set
is_good_voice = 1 where ds between '20150717' and '20151016';

--music_festival
--Wuhan strawberry
update mars_tianchi_ds set
is_music_festival = 1 where ds between '20150418' and '20150419';
--Shanghai strawberry & Suzhou midi
update mars_tianchi_ds set
is_music_festival = 1 where ds between '20150501' and '20150503';
--Changsha strawberry
update mars_tianchi_ds set
is_music_festival = 1 where ds between '20150627' and '20150628';