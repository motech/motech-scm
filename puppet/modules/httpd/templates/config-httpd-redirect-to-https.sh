if [ -n "$1" ];
then
	excludedHostAddress=$1;
	sed -i '
	$ a\
<VirtualHost \*:80>\
	RewriteEngine On \
	RewriteCond \%\{HTTPS\} off \
	RewriteCond %{HTTP_HOST} \!\^localhost \[NC\] \
	RewriteCond \%\{REMOTE_HOST\} \!\('"$excludedHostAddress"'\|127\.0\.0\.1\) \
	RewriteRule \(\.\*\) https:\/\/\%\{HTTP_HOST\}\%\{REQUEST_URI\} \
</VirtualHost>
	' /etc/httpd/conf/httpd.conf;
else
	sed -i '
	$ a\
<VirtualHost \*:80>\
	RewriteEngine On \
	RewriteCond \%\{HTTPS\} off \
	RewriteCond %{HTTP_HOST} \!\^localhost \[NC\] \
	RewriteCond %{REMOTE_HOST} \!\(127\.0\.0\.1\) \
	RewriteRule \(\.\*\) https:\/\/\%\{HTTP_HOST\}\%\{REQUEST_URI\} \
</VirtualHost>
	' /etc/httpd/conf/httpd.conf;
fi