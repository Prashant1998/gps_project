USER_DASH_QUERY = """
SELECT
    user_id,
    total_trips,
    active_days,
    avg_trip_distance_km,
    avg_speed_kmph,
    avg_idle_time_ratio,
    weekday_trip_ratio,
    night_trip_ratio
FROM mart.user_mobility_summary;
"""

ANOMALY_DASH_QUERY = """
SELECT
    user_id,
    trip_id,
    total_distance_km,
    trip_duration_min,
    avg_speed_kmph,
    idle_time_ratio,
    night_trip_flag,
    anomaly_score
FROM mart.trip_anomalies;
"""
