BEGIN {
    sql = "sqlite3 resources/data.db"
    FS = ","
    OFS = ","
    print "DROP TABLE Call311;" | sql
    print "CREATE TABLE Call311(made timetamp, resolved timestamp, latitude double, longitude double, complaint text);" | sql
    print "BEGIN TRANSACTION;" | sql
}

function parse(time) {
    split(time, arr, "[/ :]")
    return "\"" arr[3] "-" arr[1] "-" arr[2] " " (arr[7] == "PM" ? arr[4] + 12 : arr[4]) ":" arr[5] ":" arr[6] "\""
}

NR > 1 && $1 ~! "^$" && $2 ~! "^$" && $39 ~! "^$"&&  $40 ~! "^$" {
    print "INSERT INTO Call311 VALUES(" parse($2), parse($3), $39, $40, "\"" $6 "\""");" | sql
}

END {
    print "COMMIT;" | sql
}
