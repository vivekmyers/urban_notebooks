BEGIN {
    FS = ",";
    OFS = ",";
    print "DROP TABLE Taxis;";
    print "CREATE TABLE Taxis (vendor_id text,pickup_datetime timestamp,dropoff_datetime timestamp,passenger_count int,trip_distance double,pickup_longitude double,pickup_latitude double,dropoff_longitude double,dropoff_latitude double,fare_amount double,tip_amount double);";
    print "BEGIN TRANSACTION;";
}

NR > 1 {
    print "INSERT INTO Taxis VALUES (" "\""$1"\"", "\""$2"\"", "\""$3"\"", $4, $5, $6, $7, $10, $11, $13, $16 ");";
}

END {
    print "COMMIT;";
}
