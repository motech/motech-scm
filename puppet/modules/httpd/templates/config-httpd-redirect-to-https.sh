if [ -n "$1" ];
then
	excludedHostAddress=$1;
	sed -i '
	$ a\
<VirtualHost \*:80>\
	RewriteEngine On \
	RewriteCond \%\{HTTPS\} off \
	RewriteCond \%\{REMOTE_HOST\} \!\('"$excludedHostAddress"'\) \
	RewriteRule \(\.\*\) https:\/\/\%\{HTTP_HOST\}\%\{REQUEST_URI\} \
</VirtualHost>
	' /etc/httpd/conf/httpd.conf;
else
	sed -i '
	$ a\
<VirtualHost \*:80>\
	RewriteEngine On \
	RewriteCond \%\{HTTPS\} off \
	RewriteRule \(\.\*\) https:\/\/\%\{HTTP_HOST\}\%\{REQUEST_URI\} \
</VirtualHost>
	' /etc/httpd/conf/httpd.conf;
fi