httpFromPort=$1
httpToPort=$2
confFile=$3

sed -i '
/^<VirtualHost .*:'"$httpFromPort"'>$/ a\
	ProxyPassMatch \^\/\(\.\*\)\$ http:\/\/localhost:'"$httpToPort"'\/\$1
' $confFile