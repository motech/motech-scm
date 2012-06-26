virtualHost80BlockPresent=`cat httpd.conf | grep '^<VirtualHost \*:80>' | wc -l`

if [[ $virtualHost80BlockPresent -eq 0 ]];
then
	sed -i '
	$ a\
<VirtualHost \*:80>\
</VirtualHost>
	' /etc/httpd/conf/httpd.conf;
fi

if [ -n "$1" ];
then
	excludedHostAddress=$1;
	sed -i '
	/^<VirtualHost .*:80>$/ a\
	RewriteEngine On \
	RewriteCond \%\{HTTPS\} off \
	RewriteCond %{HTTP_HOST} \!\^localhost \[NC\] \
	RewriteCond \%\{REMOTE_HOST\} \!\('"$excludedHostAddress"'\|127\.0\.0\.1\) \
	RewriteRule \(\.\*\) https:\/\/\%\{HTTP_HOST\}\%\{REQUEST_URI\}
	' /etc/httpd/conf/httpd.conf;
else
	sed -i '
	/^<VirtualHost .*:80>$/ a\
	RewriteEngine On \
	RewriteCond \%\{HTTPS\} off \
	RewriteCond %{HTTP_HOST} \!\^localhost \[NC\] \
	RewriteCond \%\{REMOTE_HOST\} \!\(127\.0\.0\.1\) \
	RewriteRule \(\.\*\) https:\/\/\%\{HTTP_HOST\}\%\{REQUEST_URI\}
	' /etc/httpd/conf/httpd.conf;
fi