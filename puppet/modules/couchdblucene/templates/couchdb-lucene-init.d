#! /bin/sh
### BEGIN INIT INFO
# Provides:          couchdb-lucene
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Initscript for CouchDB-Lucene
# Description:       Initscript for CouchDB-Lucene
### END INIT INFO
case "$1" in
  start)
    /home/$motechUser/couchdb-lucene/bin/run </dev/null &> /dev/null &
    exit 0;
    ;;
  stop)
        kill -9 `ps -ef | grep couchdb-lucene | grep -v grep | awk '{print $2}'`
        ;;
esac
