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
    , rundown = string_agg(cluster_id, ', ') within group(order by timestamp_date asc, regime_id asc)
    from t03
    group by 
    timestamp_date
)
select 
rundown
, count(*)
from t04 
group by rundown
