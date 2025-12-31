from sqlalchemy import create_engine

def get_engine():
    return create_engine(
        "postgresql+psycopg2://postgres:110868@localhost:5432/geolife"
    )
