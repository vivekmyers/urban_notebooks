BEGIN {
    sql = "sqlite3 resources/data.db"
    FS = ","
    print "BEGIN TRANSACTION;" | sql
}

END {
    print "COMMIT;" | sql
}

NR > 1 {
    split($1,arr,"-")
    print "INSERT INTO Holidays VALUES(\"" arr[2] "/" arr[3] "/" arr[1] "\",\"Rosh Hashanah\");" | sql
    split($2,arr,"-")
    print "INSERT INTO Holidays VALUES(\"" arr[2] "/" arr[3] "/" arr[1] "\",\"Yom Kippur\");" | sql
}
