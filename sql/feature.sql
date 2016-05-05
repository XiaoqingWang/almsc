--time
alter table mars_tianchi_features drop column month, drop column day, drop column season, drop column weekday;
alter table mars_tianchi_features add (month int, day int, season int, weekday int);
update mars_tianchi_features
left join mars_tianchi_ds on mars_tianchi_features.ds = mars_tianchi_ds.ds set
mars_tianchi_features.month = mars_tianchi_ds.month,
mars_tianchi_features.day = mars_tianchi_ds.day,
mars_tianchi_features.season = mars_tianchi_ds.season,
mars_tianchi_features.weekday = mars_tianchi_ds.weekday;