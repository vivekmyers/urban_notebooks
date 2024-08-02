BEGIN {
    FS = ","
    OFS = ","
    sql = "sqlite3 resources/data.db"
    print "DROP TABLE Stations;" | sql
    print "CREATE TABLE Stations (name text, latitude double, longitude double);" | sql
    print "BEGIN TRANSACTION;" | sql
}

END {
    print "COMMIT;" | sql
}

NR > 1 {
    print "INSERT INTO Stations VALUES(\"" $3 "\", "$4, $5");" | sql
}
