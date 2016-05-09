drop table if exists mars_tianchi_artist_diff_actions;
create table mars_tianchi_artist_diff_actions
(
artist_id char(32),
ds char(8),
action_type char(1),
diff int,
primary key(artist_id, ds, action_type)
);
insert into mars_tianchi_artist_diff_actions 
select mars_tianchi_artists.artist_id, mars_tianchi_ds.ds, '1' as action_type, 
ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_artist_actions.artist_id = mars_tianchi_artists.artist_id and mars_tianchi_artist_actions.ds = mars_tianchi_ds.ds and mars_tianchi_artist_actions.action_type = '1'), 0)
-
ifnull((select n from mars_tianchi_artist_actions where mars_tianchi_artist_actions.artist_id = mars_tianchi_artists.artist_id and mars_tianchi_artist_actions.ds = DATE_FORMAT(ADDDATE(mars_tianchi_ds.ds, -1), '%Y%m%d') and mars_tianchi_artist_actions.action_type = '1'), 0)
from mars_tianchi_ds, mars_tianchi_artists
-------------------------------

drop table if exists mars_tianchi_artist_n_cumulative_days;
create table mars_tianchi_artist_n_cumulative_days
(
artist_id char(32),
begin char(8),
action_type char(1),
is_positive int,
n_cumulative int,
n_cumulative_days int,
primary key(artist_id, begin, action_type)
);

drop procedure if exists wk;
--/
create procedure wk() 
begin 
set @end:='20150430';
set @i:=1;
set @action_type:='1';
while @i <= 50 do
        set @artist_id:=(select artist_id from mars_tianchi_artists where artist_code = @i);
        set @avg_n:=(select avg(n) from mars_tianchi_artist_actions where artist_id = @artist_id and action_type = @action_type and ds <= @end);
        set @is_last_positive:=0;
        set @n_cumulative:=0;
        set @n_cumulative_days:=1;
        set @begin:='20150301';
        set @now:='20150302';
        while @now <= @end do
                set @is_positive:=(select if(diff/@avg_n>0.1, 1, if(diff/@avg_n<-0.1, -1, 0)) from mars_tianchi_artist_diff_actions where artist_id = @artist_id and ds = @now and action_type = @action_type);
                if @is_last_positive <> @is_positive then
                        set @n:=0;
                        if @is_positive = -1 then
                                set @n:=(select diff from mars_tianchi_artist_diff_actions where artist_id = @artist_id and ds = @now and action_type = @action_type and diff/@avg_n <-0.1);
                        end if;
                        if @is_positive = 1 then
                                set @n:=(select diff from mars_tianchi_artist_diff_actions where artist_id = @artist_id and ds = @now and action_type = @action_type and diff/@avg_n > 0.1);
                        end if;
                        insert into mars_tianchi_artist_n_cumulative_days values(@artist_id, @begin, @action_type, @is_last_positive, @n_cumulative, @n_cumulative_days);
                        set @n_cumulative:=@n;
                        set @n_cumulative_days:=1;
                        set @begin:=@now;
                else
                        set @n_cumulative=@n_cumulative+@n;
                        set @n_cumulative_days:=@n_cumulative_days+1;
                end if;
                set @is_last_positive:=@is_positive;
                set @now:=DATE_FORMAT(ADDDATE(@now, 1), '%Y%m%d');
        end while;
        set @i:=@i+1;
end while;
end;
/
call wk();
