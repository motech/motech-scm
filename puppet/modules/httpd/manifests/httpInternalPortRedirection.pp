class httpd::httpInternalPortRedirection ( $enabled ) {
	if "${enabled}" == 'true' {
	    file {"/home/${httpd::userName}/config-httpd-redirect-internal-to-port.sh" :
	        content => template("httpd/config-httpd-redirect-internal-to-port.sh"),
	        owner => "${httpd::userName}",
	        group => "${httpd::userName}",
	        mode   =>  764,
	    }

	    exec { "config-httpd-redirect-internal-to-port-for-httpd-conf":
	        require => File["/home/${httpd::userName}/config-httpd-redirect-internal-to-port.sh"],
	        command => "/bin/sh /home/${httpd::userName}/config-httpd-redirect-internal-to-port.sh ${httpd::apacheHttpPort} ${httpd::apacheTomcatPort} /etc/httpd/conf/httpd.conf"
	    }

	    exec { "config-httpd-redirect-internal-to-port-for-ssl-conf":
	        require => File["/home/${httpd::userName}/config-httpd-redirect-internal-to-port.sh"],
	        command => "/bin/sh /home/${httpd::userName}/config-httpd-redirect-internal-to-port.sh ${httpd::httpSslPort} ${httpd::apacheTomcatPort} /etc/httpd/conf.d/ssl.conf"
	    }
  	}
}