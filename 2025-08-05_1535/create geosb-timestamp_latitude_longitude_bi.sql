create view geosb.timestamp_latitude_longitude_bi as 
select 
a.*
, year = year(a.timestamp)
, month = month(a.timestamp)
, day = day(a.timestamp)
, hour = datepart(hour, a.timestamp)
, lat_long = concat(cast(a.latitude as nvarchar(50)), ',',cast(a.longitude as nvarchar(50)))
, b.cluster_id
from [geosb].[timestamp_latitude_longitude] a 
left join [geosb].[timestamp_latitude_longitude_cluster] b on a.id = b.id
