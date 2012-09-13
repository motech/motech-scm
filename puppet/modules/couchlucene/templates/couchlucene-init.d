case "$1" in

  start)
    /home/${motechUser}/couch-lucene/bin/run
    ;;
  stop)
    ps aux | grep couch-lucene | cut 3-3 | kill -9
    ;;
esac
