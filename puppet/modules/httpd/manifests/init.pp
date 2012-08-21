
class httpd ( $httpdMachine, $httpdProxyPort, $httpdMasterHost, $httpdMasterPort, $httpdSlaveHost, $httpdSlavePort, $httpToHttpsRedirectionEnabled, $httpInternalPortRedirectionEnabled, $httpsExcludedHostAddress, $apacheHttpPort, $httpSslPort, $apacheTomcatPort) {
	package { "httpd" :
		ensure => "present",
	}

  if "${httpdMachine}" == 'failoverProxy' {
     exec {
          "backup_slave_conf":
              cwd     => "/etc/httpd/conf",
              command => "cp httpd.conf httpd.conf.backup",
     }

    file {"/home/${motechUser}/config-httpd-load-balance.sh" :
        content => template("httpd/config-httpd-load-balance.sh"),
        owner => "${motechUser}",
        group => "${motechUser}",
        mode   =>  764,
    }

     exec { "config-httpd-load-balance":
         require => File["/home/${motechUser}/config-httpd-load-balance.sh"],
         command => "sh /home/${motechUser}/config-httpd-load-balance.sh ${httpdProxyPort} ${httpdMasterHost} ${httpdMasterPort} ${httpdSlaveHost} ${httpdSlavePort}"
     }
  }

	service {"httpd" :
		ensure => "running",
		enable => true,
		require => Package["httpd"],
	}
	exec {"setconnectpermission":
		command => "/usr/sbin/setsebool -P httpd_can_network_connect on>/tmp/log.txt 2>&1;",
		user => "root",
    require => Package["httpd"],
	}

  if "${httpToHttpsRedirectionEnabled}" == 'true' {
    file {"/home/${motechUser}/config-httpd-redirect-to-https.sh" :
        content => template("httpd/config-httpd-redirect-to-https.sh"),
        owner => "${motechUser}",
        group => "${motechUser}",
        mode   =>  764,
    }

     exec { "config-httpd-redirect-to-https":
         notify => Service["httpd"],
         require => File["/home/${motechUser}/config-httpd-redirect-to-https.sh"],
         command => "sh /home/${motechUser}/config-httpd-redirect-to-https.sh ${httpsExcludedHostAddress}"
     }
  }

  if "${httpInternalPortRedirectionEnabled}" == 'true' {

    file {"/home/${motechUser}/config-httpd-redirect-internal-to-port.sh" :
        content => template("httpd/config-httpd-redirect-internal-to-port.sh"),
        owner => "${motechUser}",
        group => "${motechUser}",
        mode   =>  764,
    }

     exec { "config-httpd-redirect-internal-to-port-for-httpd-conf":
         notify => Service["httpd"],
         require => File["/home/${motechUser}/config-httpd-redirect-internal-to-port.sh"],
         command => "sh /home/${motechUser}/config-httpd-redirect-internal-to-port.sh ${apacheHttpPort} ${apacheTomcatPort} /etc/httpd/conf/httpd.conf"
     }

     exec { "config-httpd-redirect-internal-to-port-for-ssl-conf":
         notify => Service["httpd"],
         require => File["/home/${motechUser}/config-httpd-redirect-internal-to-port.sh"],
         command => "sh /home/${motechUser}/config-httpd-redirect-internal-to-port.sh ${httpSslPort} ${apacheTomcatPort} /etc/httpd/conf.d/ssl.conf"
     }
  }
}
