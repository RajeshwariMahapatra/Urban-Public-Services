import requests
import pandas as pd
import os
import time

URL = "https://data.cityofnewyork.us/resource/erm2-nwe9.json"

OUTPUT_FILE = "data/raw/nyc_311_2025.csv"

SELECT_FIELDS = (
    "unique_key,created_date,closed_date,agency,agency_name,"
    "complaint_type,descriptor,location_type,status,borough,"
    "incident_zip,community_board,open_data_channel_type,"
    "latitude,longitude"
)

BATCH_SIZE = 50000
TARGET_RECORDS = 500000

os.makedirs("data/raw", exist_ok=True)

all_data = []

for offset in range(0, TARGET_RECORDS, BATCH_SIZE):

    params = {
        "$limit": BATCH_SIZE,
        "$offset": offset,
        "$where": (
            "created_date between "
            "'2025-01-01T00:00:00' and "
            "'2025-12-31T23:59:59'"
        ),
        "$select": SELECT_FIELDS,
        "$order": "created_date ASC"
    }

    print(f"Downloading records {offset:,} - {offset + BATCH_SIZE:,}...")

    response = requests.get(URL, params=params)

    if response.status_code != 200:
        print("Error:", response.status_code)
        print(response.text)
        break

    batch = response.json()

    if not batch:
        print("No more records available.")
        break

    all_data.extend(batch)

    print(f"Received: {len(batch):,} records")

    time.sleep(1)


df = pd.DataFrame(all_data)

df.to_csv(OUTPUT_FILE, index=False)

print("\nDownload complete!")
print("Records:", len(df))
print("Columns:", len(df.columns))
print("File:", OUTPUT_FILE)