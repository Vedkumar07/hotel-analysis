# Weather-Cancellation Analyzer

## What it does
Fetches historical daily weather (precipitation, max temperature)
for Goa and Manali from the Open-Meteo ERA5 API and tests whether
heavy rain or extreme temperatures correlate with higher hotel
booking cancellation rates.

## How to run
1. Place hotel_bookings.csv in the parent folder
2. Open weather_analyzer.ipynb in Jupyter Notebook
3. Run all cells top to bottom (Shift+Enter each cell)
4. Chart saves automatically as weather_cancellation.png

## Design decision
One API call per city covering the full date range (not one call
per booking row) — reduces API calls from 1,500+ to 2,
avoiding rate limits and improving performance.

## Limitation
Weather data reflects city-level conditions, not microclimate
at the specific property. A hotel in North Goa may experience
different rainfall than South Goa on the same day.