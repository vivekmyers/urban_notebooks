all: resources database

resources: clean 
	mkdir resources
	curl -L "https://github.com/fivethirtyeight/uber-tlc-foil-response/raw/master/uber-trip-data/uber-raw-data-janjune-15.csv.zip" -o resources/uber.csv
	curl -L "https://data.cityofnewyork.us/api/views/h9gi-nx95/rows.csv?accessType=DOWNLOAD" -o resources/accidents.csv
	curl -L "https://gist.githubusercontent.com/shivaas/4758439/raw/b0d3ddec380af69930d0d67a9e0519c047047ff8/US%2520Bank%2520holidays" -o resources/holidays.csv
	curl -L "https://gist.githubusercontent.com/jtoll/ce463b9e2727ac42389c/raw/0b69f6083b7f167d868f603da93a21948b326223/holidays.csv" -o resources/jewish.csv
	curl -L "https://data.cityofnewyork.us/api/views/s7zz-qmyz/rows.csv?accessType=DOWNLOAD" -o resources/lines.csv
	curl https://www.ncei.noaa.gov/orders/cdo/1440778.csv -o resources/weather.csv
	curl -L "https://data.cityofnewyork.us/api/geospatial/tqmj-j8zm?method=export&format=GeoJSON" -o resources/roads.geojson
	curl -L "https://nycopendata.socrata.com/api/views/erm2-nwe9/rows.csv?accessType=DOWNLOAD" -o resources/311.csv
	curl -L "https://data.ny.gov/api/views/i9wp-a4ja/rows.csv?accessType=DOWNLOAD" -o resources/subway_locations.csv
	curl -L "https://s3-us-west-2.amazonaws.com/nyctlc/nyc_taxi_data.csv.gz" -o resources/taxis.csv
	for i in {1..6}; do curl -L "https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2015-0$i.csv"; done > resources/taxis2015.csv
	curl -L "https://data.ny.gov/api/views/ekwu-khcy/rows.csv?accessType=DOWNLOAD" -o resources/turnstiles.csv

database:
	-awk -f utils/311-sql.awk resources/311.csv
	-awk -f utils/accidents-sql.awk resources/accidents.csv
	-awk -f utils/holidays-sql.awk resources/holidays.csv
	-awk -f utils/jewish.awk resources/jewish.csv
	-awk -f utils/locations.awk resources/subway_locations.csv
	-awk -f utils/taxis-sql.awk resources/taxis.csv
	-awk -f utils/tolls.awk resources/tolls.csv
	-awk -f utils/turnstiles.awk resources/turnstiles.csv

clean:
	rm -rf resources
