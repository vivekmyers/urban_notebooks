BEGIN {
    sql = "sqlite3 resources/data.db"
    print "DROP TABLE Subways;" | sql
    print "BEGIN TRANSACTION;" | sql
    print "CREATE TABLE Subways(name text,time timestamp,entries int,exits int);" | sql
    FS = ","
    OFS = ","
}

END {
    print "COMMIT;" | sql
    close(sql)
}

function abs(x) {
    return x > 0 ? x : -x
}

{ 
    if (NR % 100000 == 0)
        print (NR / 440000) > "/dev/stderr"
    ent = $10
    ex = $11
    if ($3 == name) {
        $10 = abs(lastent - $10)
        $11 = abs(lastex - $11)
        if ($10 > 10000) $10 = "ERROR"
        if ($11 > 10000) $11 = "ERROR"
    } else {
        $10 = 0
        $11 = 0
    }
    split($7,arr,"/")
    $7 = arr[3]"-"arr[1]"-"arr[2]
    if ($10 != "ERROR" && $11 != "ERROR")
        print "INSERT INTO Subways VALUES(\""$4"\"","\""$7" "$8"\"",$10,$11");" | sql
    name = $3
    lastent = ent
    lastex = ex
}

