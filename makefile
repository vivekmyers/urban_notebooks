all: resources/data.db resources/uber.csv

resources:
	mkdir resources

resources/uber.csv: | resources
	curl -L "https://github.com/fivethirtyeight/uber-tlc-foil-response/raw/master/uber-trip-data/uber-raw-data-janjune-15.csv.zip" -o $@

resources/accidents.csv: | resources
	curl -L "https://data.cityofnewyork.us/api/views/h9gi-nx95/rows.csv?accessType=DOWNLOAD" -o $@

resources/holidays.csv: | resources
	curl -L "https://gist.githubusercontent.com/shivaas/4758439/raw/b0d3ddec380af69930d0d67a9e0519c047047ff8/US%2520Bank%2520holidays" -o $@

resources/jewish.csv: | resources
	curl -L "https://gist.githubusercontent.com/jtoll/ce463b9e2727ac42389c/raw/0b69f6083b7f167d868f603da93a21948b326223/holidays.csv" -o $@

resources/lines.csv: | resources
	curl -L "https://data.cityofnewyork.us/api/views/s7zz-qmyz/rows.csv?accessType=DOWNLOAD" -o $@

resources/weather.csv: | resources
	curl -L https://www.ncei.noaa.gov/orders/cdo/1440778.csv -o $@

resources/roads.geojson: | resources
	curl -L "https://data.cityofnewyork.us/api/geospatial/tqmj-j8zm?method=export&format=GeoJSON" -o $@

resources/311.csv: | resources
	curl -L "https://nycopendata.socrata.com/api/views/erm2-nwe9/rows.csv?accessType=DOWNLOAD" -o $@

resources/subway_locations.csv: | resources
	curl -L "https://data.ny.gov/api/views/i9wp-a4ja/rows.csv?accessType=DOWNLOAD" -o $@

resources/taxis.csv: | resources
	curl -L "https://s3-us-west-2.amazonaws.com/nyctlc/nyc_taxi_data.csv.gz" -o $@

resources/taxis2015.csv: | resources
	for i in {1..6}; do curl -L "https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2015-0$i.csv"; done > $@

resources/turnstiles.csv: | resources
	curl -L "https://data.ny.gov/api/views/ekwu-khcy/rows.csv?accessType=DOWNLOAD" -o $@

resources/data.db: resources/accidents.csv resources/holidays.csv resources/jewish.csv resources/lines.csv resources/weather.csv resources/roads.geojson resources/311.csv resources/subway_locations.csv resources/taxis.csv resources/taxis2015.csv resources/turnstiles.csv
	$(MAKE) $(foreach file,$^,resources/process_$(file))

resources/process_%:
	awk -f utils/$(basename $*).awk resources/$*
	touch $@

clean:
	rm -rf resources
