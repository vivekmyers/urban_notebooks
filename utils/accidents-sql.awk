BEGIN {
    FS = ",";
    OFS = ",";
    print "DROP TABLE Accidents;"
    print "CREATE TABLE Accidents(time datetime, latitude double, longitude double, person_injured int, person_killed int, pedestrian_injured int, pedestrian_killed int, cyclist_injured int, cyclist_killed int, motorist_injured int, motorist_killed int, vehicle1 text, vehicle2 text, vehicle3 text, vehicle4 text, vehicle5 text);";
    print "BEGIN TRANSACTION;";
}

NR > 1 {
    gsub("/", "-", $1);
    split($1, arr, "-");
    $1 = arr[3] "-" arr[1] "-" arr[2];
    split($2, arr, ":");
    if (arr[1] < 10) arr[1] = "0" arr[1];
    if ($5 != "" && $6 != ""  && $12 != "" && $13 != "" && $14 != "" && $15 != "" && $16 != "" && $17 != "" && $18 != "" && $19 != "")
    print "INSERT INTO Accidents VALUES(" "\""$1 " " arr[1] ":" arr[2]  ":00\"", $5, $6, $12, $13, $14, $15, $16, $17, $18, $19, "\""$26"\"", "\""$27"\"", "\""$28"\"", "\""$29"\"", "\""$30"\"" ");";
}

END {
    print "COMMIT;";
}
