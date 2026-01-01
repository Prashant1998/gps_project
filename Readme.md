# GeoLife Mobility Analytics

An end-to-end, SQL-first mobility analytics project built on the GeoLife GPS Trajectory dataset.  
The project engineers trip- and user-level features in PostgreSQL, applies rule-based anomaly detection, and exposes insights through an interactive Streamlit dashboard.

## Architecture
- **Data**: GeoLife GPS Trajectories
- **Storage & Analytics**: PostgreSQL (staging → marts)
- **Processing**: SQL + Python
- **Visualization**: Streamlit
- **Config**: Environment variables via `.env`

## Features
- Trip-level feature engineering (distance, duration, speed, idle ratio)
- User-level mobility summaries (active days, averages, ratios)
- Rule-based anomaly detection
- Interactive dashboard with user drill-down and anomaly filtering

## Project Structure
geolife-mobility-analytics/
├── app/
│ ├── app.py
│ ├── db.py
│ └── queries.py
├── notebooks/
├── data/
├── .env
├── .gitignore
└── README.md

## How to Run
1. Create a `.env` file in the project root:
DB_USER=postgres
DB_PASSWORD=your_password
DB_HOST=localhost
DB_PORT=5432
DB_NAME=geolife

Install dependencies:
pip install streamlit sqlalchemy psycopg2-binary python-dotenv pandas

Run the app:
streamlit run app/app.py

## Dashboard
- User-level overview with filters
- Trip anomaly table with severity slider
- Anomaly score distribution chart

## Notes
- Logic validated on a subset before scaling
- SQL remains the source of truth; UI is thin by design
### Screenshots
![User Overview](screenshots/user_overview.png)
![Anomalies](screenshots/anomaly.png)


## Performance & Scaling Notes

The analytics pipeline was validated on a 50-user subset of the GeoLife dataset.  
Given the extremely high density of GPS points in GeoLife, this scale is sufficient to:

- Validate trip segmentation correctness
- Verify user-level aggregation logic
- Observe performance characteristics of SQL window functions and aggregations
- Ensure interactive dashboard responsiveness in a local environment

Beyond this scale, additional local scaling yields diminishing returns and would be better evaluated in a distributed or cloud-based setup. The pipeline design allows scaling by adjusting the ingestion layer without modifying analytical logic.

## Live Demo
🔗 https://https://geolifeanalytics.streamlit.app/


Data is stored in PostgreSQL (Neon).
Transformations are implemented as SQL marts.
Streamlit is used purely as the presentation layer.


