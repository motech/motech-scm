#! /bin/sh

wget --spider --tries 10 --retry-connrefused --no-check-certificate http://localhost:5984/

dbs=$1
master=$2

p1='{"source": "http://'
p2=':5984/'
p3='","target": "'
p4='", "create_target": true, "continuous": true, "user_ctx": { "roles": ["_admin"] } }'

for db in $dbs; {
    payload=$p1"$master"$p2"$db"$p3"$db"$p4
    curl -H 'Content-Type: application/json' -X POST http://localhost:5984/_replicator -d "$payload"
}
