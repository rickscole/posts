
create procedure geosb.create_timestamp_latitude_longitude_day_path as

-- drop table if exists
if object_id('geosb.timestamp_latitude_longitude_day_path', 'U') is not null
drop table geosb.timestamp_latitude_longitude_day_path; 


;
with t00 as 
(
    select 
    a.*
    , b.cluster_id
    , timestamp_date = cast(a.[timestamp] as date) 
    from [geosb].[timestamp_latitude_longitude] a 
    inner join [geosb].[timestamp_latitude_longitude_cluster] b on a.id = b.id 
),
t01 as 
(
    select 
    timestamp_date
    , cluster_id
    , case when lag(cluster_id) over (order by timestamp_date) = cluster_id then 0 else 1 end as is_new_regime
    from t00
),
t02 as 
(
    select 
    timestamp_date
    , cluster_id
    , regime_id = sum(is_new_regime) over (order by timestamp_date rows unbounded preceding)
    from t01 
), 
t03 as 
(
    select 
    timestamp_date 
    , cluster_id 
    , regime_id 
    from t02
    group by 
    timestamp_date 
    , cluster_id 
    , regime_id 
),
t04 as 
(
    select 
    timestamp_date
    , day_path = string_agg(cluster_id, ', ') within group(order by timestamp_date asc, regime_id asc)
    from t03
    group by 
    timestamp_date
)
select 
    a.id
    , c.day_path
into geosb.timestamp_latitude_longitude_day_path
from [geosb].[timestamp_latitude_longitude_cluster] a 
inner join [geosb].[timestamp_latitude_longitude] b on a.id = b.id 
inner join t04 c on cast(b.[timestamp] as date) = c.timestamp_date

