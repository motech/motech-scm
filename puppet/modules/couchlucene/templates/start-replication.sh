#! /bin/sh

wget --spider --tries 10 --retry-connrefused --no-check-certificate http://localhost:5984/

master="<%= couchMaster %>"
dbs="<%= couchDbs %>"

p1='{"source": "http://'
p2=':5984/'
p3='", "target": "'
p4='", "_id": "'
p5='", "create_target": true, "continuous": true, "user_ctx": { "roles": ["_admin"] } }'

for db in $dbs; {
    payload=$p1"$master"$p2"$db"$p3"$db"$p4"$db"$p5
    curl -H 'Content-Type: application/json' -X POST http://localhost:5984/_replicator -d "$payload"
}
