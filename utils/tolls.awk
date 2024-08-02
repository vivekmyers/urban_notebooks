BEGIN {
    sql = "sqlite3 resources/tolls.db"
    FS = ","
    OFS = ","
    print "DROP TABLE Tolls;" | sql
    print "CREATE TABLE Tolls(time timestamp, etc int, cash int, traffic int);" | sql
    print "BEGIN TRANSACTION;" | sql
}

function parse(time) {
    split(time, arr, "/")
    return "\"" arr[3] "-" (arr[1] < 10 ? "0" : "") arr[1] "-"  (arr[2] < 10 ? "0" : "") arr[2] "\""
}

NR > 1 {
    print "INSERT INTO Tolls VALUES("parse($2), $3, $4 + "0", $3 + $4");" | sql
}

END {
    print "COMMIT;" | sql
}
