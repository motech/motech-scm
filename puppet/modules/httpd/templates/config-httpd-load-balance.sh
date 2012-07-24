httpProxyPort=$1
httpMasterHost=$2
httpMasterPort=$3
httpSlaveHost=$4
httpSlavePort=$5

sed -i '
/^Listen 80$/a \
Listen '"$httpProxyPort"'
' /etc/httpd/conf/httpd.conf

sed -i '
$ a\
<VirtualHost \*:'"$httpProxyPort"'>\
    ProxyPass \/ balancer:\/\/hotcluster\/ \
    <Proxy balancer:\/\/hotcluster> \
        Order Deny,Allow \
        Deny from all \
        Allow from localhost \
        BalancerMember http:\/\/'"$httpMasterHost"':'"$httpMasterPort"' \
        # The below is the hot standby \
        BalancerMember http:\/\/'"$httpSlaveHost"':'"$httpSlavePort"' status=\+H \
    <\/Proxy> \
<\/VirtualHost>
' /etc/httpd/conf/httpd.conf