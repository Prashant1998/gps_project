--02_user_aggregation
CREATE TABLE mart.user_mobility_summary AS
SELECT
    user_id,

    COUNT(*) AS total_trips,
    SUM(total_distance_km) AS total_distance_km,
    AVG(total_distance_km) AS avg_trip_distance_km,

    AVG(trip_duration_min) AS avg_trip_duration_min,
    AVG(avg_speed_kmph) AS avg_speed_kmph,

    AVG(idle_time_ratio) AS avg_idle_time_ratio,
    AVG(trip_efficiency) AS avg_trip_efficiency

FROM mart.trip_features
GROUP BY user_id;
--temporal_behaviour_columns
ALTER TABLE mart.user_mobility_summary
ADD COLUMN weekday_trip_ratio DOUBLE PRECISION,
ADD COLUMN night_trip_ratio DOUBLE PRECISION;
--rewritting night_flag  due to error
UPDATE mart.trip_features
SET night_trip_flag =
    CASE
        WHEN EXTRACT(hour FROM trip_start_time) >= 22
          OR EXTRACT(hour FROM trip_start_time) <= 5
        THEN 1
        ELSE 0
    END;
	
UPDATE mart.user_mobility_summary u
SET night_trip_ratio = t.night_ratio
FROM (
    SELECT
        user_id,
        AVG(night_trip_flag) AS night_ratio
    FROM mart.trip_features
    GROUP BY user_id
) t
WHERE u.user_id = t.user_id;

UPDATE mart.user_mobility_summary u
SET
    weekday_trip_ratio = t.weekday_ratio
   
FROM (
    SELECT
        user_id,
        AVG(weekday_flag) AS weekday_ratio
  
    FROM mart.trip_features
    GROUP BY user_id
) t
WHERE u.user_id = t.user_id;

-- checking_variability

ALTER TABLE mart.user_mobility_summary
ADD COLUMN distance_variability DOUBLE PRECISION,
ADD COLUMN duration_variability DOUBLE PRECISION;

UPDATE mart.user_mobility_summary u
SET
    distance_variability = t.dist_var,
    duration_variability = t.dur_var
FROM (
    SELECT
        user_id,
        STDDEV_POP(total_distance_km) AS dist_var,
        STDDEV_POP(trip_duration_min) AS dur_var
    FROM mart.trip_features
    GROUP BY user_id
) t
WHERE u.user_id = t.user_id;
--active_days
CREATE OR REPLACE VIEW mart.trip_dates AS
SELECT
    user_id,
    DATE(trip_start_time) AS trip_date
FROM mart.trip_features;
ALTER TABLE mart.user_mobility_summary
ADD COLUMN active_days INTEGER,
ADD COLUMN trips_per_active_day DOUBLE PRECISION;
UPDATE mart.user_mobility_summary u
SET
    active_days = t.active_days,
    trips_per_active_day = u.total_trips * 1.0 / t.active_days
FROM (
    SELECT
        user_id,
        COUNT(DISTINCT trip_date) AS active_days
    FROM mart.trip_dates
    GROUP BY user_id
) t
WHERE u.user_id = t.user_id;




