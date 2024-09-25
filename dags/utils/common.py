from datetime import datetime, timedelta
import requests
import json

# Function to fetch data from OpenWeatherMap API
def fetch_weather_data():
    api_key = 'your_openweathermap_api_key'  # Replace with your API key
    city = 'London'
    url = f'http://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}'
    
    response = requests.get(url)
    data = response.json()
    
    # Save the data to a local file or storage system
    with open(f'/path/to/storage/weather_{datetime.now().date()}.json', 'w') as f:
        json.dump(data, f)
