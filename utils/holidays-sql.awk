BEGIN {
    sql = "sqlite3 resources/data.db"
    FS = ","
    print "DROP TABLE Holidays;" | sql
    print "CREATE TABLE Holidays (date text, name text);" | sql
    print "BEGIN TRANSACTION;" | sql
}

END {
    print "COMMIT;" | sql
}

{
    split($2,arr,"-")
    print "INSERT INTO Holidays VALUES(\"" arr[2] "/" arr[3] "/" arr[1] "\",\"" $3 "\");" | sql
}
