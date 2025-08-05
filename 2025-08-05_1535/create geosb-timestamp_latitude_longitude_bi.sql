create view geosb.timestamp_latitude_longitude_bi as 
select 
a.*
, year = year(timestamp)
, month = month(timestamp)
, day = day(timestamp)
, hour = datepart(hour, timestamp)
, lat_long = concat(cast(a.latitude as nvarchar(50)), ',',cast(a.longitude as nvarchar(50)))
from [geosb].[timestamp_latitude_longitude] a 
