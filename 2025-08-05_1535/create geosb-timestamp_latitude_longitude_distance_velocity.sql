
create procedure geosb.create_timestamp_latitude_longitude_distance_velocity as

-- pre drop tables
if object_id('geosb.timestamp_latitude_longitude_distance_velocity', 'U') is not null
drop table geosb.timestamp_latitude_longitude_distance_velocity; 


with t00 as 
(
select 
a.*
, timestamp_rank_id = row_number() over(order by a.timestamp asc)
from [geosb].[timestamp_latitude_longitude] a 
)
select
d.id 
, d.latitude 
, d.longitude
, d.time_difference_seconds_before
, d.distance_difference_miles_before
, d.time_difference_seconds_after
, d.distance_difference_miles_after
, miles_per_second_before = distance_difference_miles_before / time_difference_seconds_before
, miles_per_second_after = (-1 ) * distance_difference_miles_after / time_difference_seconds_after
, are_both_velocities_over_threshold = case when distance_difference_miles_before / time_difference_seconds_before > .001 and (-1 ) * distance_difference_miles_after / time_difference_seconds_after >.001 then 1 else 0 end
into geosb.timestamp_latitude_longitude_distance_velocity
from 
(
select 
    a.* 
    , time_difference_seconds_before = datediff(second, b.timestamp, a.timestamp)
    , distance_difference_miles_before = 69.69 * degrees(acos(least(1.0, cos(radians(b.latitude)) * cos(radians(a.latitude)) * cos(radians(b.longitude - a.longitude)) + sin(radians(b.latitude)) * sin(radians(a.latitude)))))
    , time_difference_seconds_after = datediff(second, c.timestamp, a.timestamp)
    , distance_difference_miles_after = 69.69 * degrees(acos(least(1.0, cos(radians(c.latitude)) * cos(radians(a.latitude)) * cos(radians(c.longitude - a.longitude)) + sin(radians(c.latitude)) * sin(radians(a.latitude)))))
from t00 a 
left join t00 b on a.timestamp_rank_id = b.timestamp_rank_id + 1
left join t00 c on a.timestamp_rank_id = c.timestamp_rank_id - 1
)
d
