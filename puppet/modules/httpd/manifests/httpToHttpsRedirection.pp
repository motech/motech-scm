class httpd::httpToHttpsRedirection ( $enabled ) {
	if "${enabled}" == 'true' {
        file {"/home/${httpd::userName}/config-httpd-redirect-to-https.sh" :
            content => template("httpd/config-httpd-redirect-to-https.sh"),
            owner => "${httpd::userName}",
            group => "${httpd::userName}",
            mode   =>  764,
        }

        exec { "config-httpd-redirect-to-https":
            require => File["/home/${httpd::userName}/config-httpd-redirect-to-https.sh"],
            command => "/bin/sh /home/${httpd::userName}/config-httpd-redirect-to-https.sh ${httpd::httpsExcludedHostAddress}"
        }
    }
}