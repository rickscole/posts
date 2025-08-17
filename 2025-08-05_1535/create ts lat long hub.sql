SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [geosb].[create_timestamp_latitude_longitude_hub] as 

-- pre drop tables
if object_id('geosb.timestamp_latitude_longitude_hub', 'U') is not null
drop table geosb.timestamp_latitude_longitude_hub; 


select 
a.*
, timestamp_day = cast(a.[timestamp] as date)
, year = year(a.timestamp)
, month = month(a.timestamp)
, day = day(a.timestamp)
, hour = datepart(hour, a.timestamp)
, hour_bucket = 
    case 
    when datepart(hour, a.timestamp) <= 4 then '12 AM to 4 AM'
    when datepart(hour, a.timestamp) <= 8 then '4 AM to 8 AM'
    when datepart(hour, a.timestamp) <= 12 then '8 AM to 12 PM'
    when datepart(hour, a.timestamp) <= 16 then '12 PM to 4 PM'
    when datepart(hour, a.timestamp) <= 20 then '4 PM to 8 PM'
    when datepart(hour, a.timestamp) <= 24 then '8 PM to 12 AM'
    else null 
    end
, hour_bucket_order = 
    case 
    when datepart(hour, a.timestamp) <= 4 then 0
    when datepart(hour, a.timestamp) <= 8 then 1
    when datepart(hour, a.timestamp) <= 12 then 2
    when datepart(hour, a.timestamp) <= 16 then 3
    when datepart(hour, a.timestamp) <= 20 then 4
    when datepart(hour, a.timestamp) <= 24 then 5
    else null 
    end
, lat_long = concat(cast(a.latitude as nvarchar(50)), ',',cast(a.longitude as nvarchar(50)))
, b.cluster_id
, cluster_name = case when b.id is null then 'Bad Reading' else coalesce(c.cluster_name, concat('Cluster ', b.cluster_id)) end
, workday_or_nonworkday = case when d.id is not null or datepart(weekday, a.timestamp) in (7, 1) then 'Non-Workday' else 'Workday' end
, e.day_path
into geosb.timestamp_latitude_longitude_hub
from [geosb].[timestamp_latitude_longitude] a 
left join [geosb].[timestamp_latitude_longitude_cluster] b on a.id = b.id
left join 
(
    select 0 as cluster_id, 'Home' as cluster_name
    union select 1, 'Work'
    union select 2, 'Gym'
    union select -1, 'ANOMALY'
) c 
on b.cluster_id =  c.cluster_id
left join 
(
    select id, holiday, date = cast(date as date) from geosb.holiday 
    union select id, holiday, date = cast(observed_date as date)  from geosb.holiday
)
d on cast(a.timestamp as date) = d.date
left join geosb.timestamp_latitude_longitude_day_path e on a.id = e.id



GO
