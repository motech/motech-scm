httpFromPort=$1
httpToPort=$2
confFile=$3

virtualHost80BlockPresent=`cat $confFile | grep '^<VirtualHost .*:'"$httpFromPort"'>' | wc -l`

if [[ $virtualHost80BlockPresent -eq 0 ]];
then
	sed -i '
	$ a\
<VirtualHost \*:'"$httpFromPort"'>\
</VirtualHost>
	' $confFile;
fi

sed -i '
/^<VirtualHost .*:'"$httpFromPort"'>$/ a\
	ProxyPassMatch \^\/\(\.\*\)\$ http:\/\/localhost:'"$httpToPort"'\/\$1
' $confFile