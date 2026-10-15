import requests

url = "https://data.cityofnewyork.us/resource/erm2-nwe9.json"

params = {
    "$limit": 5,
    "$where": "created_date between '2025-01-01T00:00:00' and '2025-12-31T23:59:59'",
    "$select": "unique_key,created_date,closed_date,agency,agency_name,complaint_type,descriptor,location_type,status,borough,incident_zip,community_board,open_data_channel_type,latitude,longitude"
}

response = requests.get(url, params=params)

print("Status:", response.status_code)
print(response.text[:5000])