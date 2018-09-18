resources: 
	rm -rf resources
	mkdir resources
	tar -xvf resources.tar.gz -C resources

database:
	awk -f utils/311-sql.awk resources/311.csv
	awk -f utils/accidents-sql.awk resources/accidents.csv
	awk -f utils/holidays-sql.awk resources/holidays.csv
	awk -f utils/jewish.awk resources/jewish.csv
	awk -f utils/locations.awk resources/subway_locations.csv
	awk -f utils/taxis-sql.awk resources/taxis.csv
	awk -f utils/tolls.awk resources/tolls.csv
	awk -f utils/turnstiles.awk resources/turnstiles.csv

