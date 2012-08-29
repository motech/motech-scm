class httpd::failoverProxy ( $httpdMachine ) {
	if "${httpdMachine}" == 'failoverProxy' {
	    file {"/home/${httpd::userName}/config-httpd-load-balance.sh" :
	        content => template("httpd/config-httpd-load-balance.sh"),
	        owner => "${httpd::userName}",
	        group => "${httpd::userName}",
	        mode   =>  764,
	    }

		exec { "config-httpd-load-balance":
			require => File["/home/${httpd::userName}/config-httpd-load-balance.sh"],
			command => "/bin/sh /home/${httpd::userName}/config-httpd-load-balance.sh ${httpd::httpdProxyPort} ${httpd::httpdMasterHost} ${httpd::httpdMasterPort} ${httpd::httpdSlaveHost} ${httpd::httpdSlavePort}"
		}
  }
}