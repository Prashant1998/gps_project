-- 01_schema.sql
-- Purpose: Create schemas and table used in the project


CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS mart;

CREATE TABLE mart.trip_features(
    user_id TEXT,
    trip_id INTEGER,
    trip_start_time TIMESTAMP,
    trip_end_time TIMESTAMP,
    trip_duration_min DOUBLE PRECISION,
    total_distance_km DOUBLE PRECISION,
    avg_speed_kmph DOUBLE PRECISION,
    max_speed_kmph DOUBLE PRECISION,
    num_points INTEGER,
    idle_time_ratio DOUBLE PRECISION,
    bounding_box_area DOUBLE PRECISION,
    night_trip_flag INTEGER,
    weekday_flag INTEGER,
    trip_efficiency DOUBLE PRECISION
);
COPY mart.trip_features
FROM 'D:\projects\gps_project\Data\trip_feature_clean.csv'
DELIMITER ','
CSV HEADER;

