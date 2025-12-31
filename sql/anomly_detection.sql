
-- STEP 3: Rule-Based Trip Anomaly Detection
-- Each row = one trip with anomaly flags

CREATE TABLE mart.trip_anomalies AS
SELECT
    tf.*,

    -- 1. Speed anomaly (physically unrealistic or suspicious)
    CASE
        WHEN tf.avg_speed_kmph > 120 OR tf.max_speed_kmph > 160
        THEN 1 ELSE 0
    END AS speed_anomaly,

    -- 2. Distance anomaly (very long trips)
    CASE
        WHEN tf.total_distance_km > 200
        THEN 1 ELSE 0
    END AS distance_anomaly,

    -- 3. Duration anomaly (very long continuous trips)
    CASE
        WHEN tf.trip_duration_min > 300
        THEN 1 ELSE 0
    END AS duration_anomaly,

    -- 4. Spatial anomaly (unusual spatial spread)
    CASE
        WHEN tf.bounding_box_area > 0.5
        THEN 1 ELSE 0
    END AS spatial_anomaly,

    -- 5. Temporal anomaly (long + fast + night)
    CASE
        WHEN tf.night_trip_flag = 1
         AND tf.trip_duration_min > 120
         AND tf.avg_speed_kmph > 60
        THEN 1 ELSE 0
    END AS night_behavior_anomaly

FROM mart.trip_features tf;

--anamoly score
ALTER TABLE mart.trip_anomalies
ADD COLUMN anomaly_score INTEGER;
UPDATE mart.trip_anomalies
SET anomaly_score =
      speed_anomaly
    + distance_anomaly
    + duration_anomaly
    + spatial_anomaly
    + night_behavior_anomaly;

--distribution_check
SELECT
    anomaly_score,
    COUNT(*) AS trip_count
FROM mart.trip_anomalies
GROUP BY anomaly_score
ORDER BY anomaly_score;

--inspecting anamolies
SELECT
    user_id,
    trip_id,
    total_distance_km,
    avg_speed_kmph,
    trip_duration_min,
    anomaly_score
FROM mart.trip_anomalies
WHERE anomaly_score >= 2
ORDER BY anomaly_score DESC
LIMIT 20;

--user level anomaly
CREATE TABLE mart.user_anomaly_summary AS
SELECT
    user_id,
    COUNT(*) AS total_trips,
    SUM(CASE WHEN anomaly_score > 0 THEN 1 ELSE 0 END) AS anomalous_trips,
    AVG(anomaly_score) AS avg_anomaly_score
FROM mart.trip_anomalies
GROUP BY user_id;

