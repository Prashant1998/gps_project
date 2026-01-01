from app.db import get_engine
from app.queries import USER_DASH_QUERY, ANOMALY_DASH_QUERY

import streamlit as st
import pandas as pd
from sqlalchemy import create_engine

# --- DB connection (same as notebook) ---
engine = get_engine()

st.title("GeoLife – User Mobility Overview")

# --- Load dashboard-ready data ---
query = USER_DASH_QUERY

user_dash_df = pd.read_sql(query, engine)
# --- User filter ---
st.subheader("Filter by User")

user_list = ["All"] + sorted(user_dash_df["user_id"].unique().tolist())
selected_user = st.selectbox("Select user", user_list)

if selected_user != "All":
    user_dash_df = user_dash_df[user_dash_df["user_id"] == selected_user]

# --- Display ---
st.dataframe(user_dash_df)

st.markdown("---")
st.subheader("Trip Anomalies")

# --- Load anomaly data ---
anomaly_query = ANOMALY_DASH_QUERY

anomaly_df = pd.read_sql(anomaly_query, engine)

# --- Apply same user filter ---
if selected_user != "All":
    anomaly_df = anomaly_df[anomaly_df["user_id"] == selected_user]

# --- Optional anomaly threshold ---
min_score = st.slider(
    "Minimum anomaly score",
    int(anomaly_df["anomaly_score"].min()),
    int(anomaly_df["anomaly_score"].max()),
    1
)

anomaly_df = anomaly_df[anomaly_df["anomaly_score"] >= min_score]

# --- Display ---
st.dataframe(anomaly_df)


st.markdown("---")
st.subheader("Anomaly Score Distribution")

# Count trips by anomaly score
score_counts = (
    anomaly_df["anomaly_score"]
    .value_counts()
    .sort_index()
)

st.bar_chart(score_counts)


