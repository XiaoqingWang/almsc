set @train_begin:='20150501';
set @train_end:='20150630';
set @test_begin:='20150701';
set @test_end:='20150830';

--sample
drop table if exists mars_tianchi_features;
create table mars_tianchi_features
(
artist_id char(32),
ds char(8),
plays int,
is_train char(1), --1:train,0:test
primary key(artist_id, ds)
);
--train
insert into mars_tianchi_features(artist_id, ds, plays, is_train)
select artist_id, ds, n as plays, '1' as is_train from mars_tianchi_artist_actions
where action_type = '1' and ds between @train_begin and @train_end;
--test
insert into mars_tianchi_features(artist_id, ds, plays, is_train)
select artist_id, ds, n as plays, '0' as is_train from mars_tianchi_artist_actions
where action_type = '1' and ds between @test_begin and @test_end;