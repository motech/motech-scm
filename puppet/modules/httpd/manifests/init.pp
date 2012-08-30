
class httpd ( $userName, $httpdMachine, $httpdProxyPort, $httpdMasterHost, $httpdMasterPort, $httpdSlaveHost, $httpdSlavePort, $httpToHttpsRedirectionEnabled, $httpInternalPortRedirectionEnabled, $httpsExcludedHostAddress, $apacheHttpPort, $httpSslPort, $apacheTomcatPort) {
    package { "httpd" :
        ensure => "present",
    }

    if "${httpdMachine}" == 'failoverProxy' {
        file {"/home/${httpd::userName}/config-httpd-load-balance.sh" :
            content => template("httpd/config-httpd-load-balance.sh"),
            owner => "${httpd::userName}",
            group => "${httpd::userName}",
            mode   =>  764,
        }

        exec { "config-httpd-load-balance":
            require => File["/home/${httpd::userName}/config-httpd-load-balance.sh"],
            command => "/bin/sh /home/${httpd::userName}/config-httpd-load-balance.sh ${httpd::httpdProxyPort} ${httpd::httpdMasterHost} ${httpd::httpdMasterPort} ${httpd::httpdSlaveHost} ${httpd::httpdSlavePort}",
            notify => Service["httpd"],
        }
    }

    # class { "httpd::failoverProxy" :
    #     httpdMachine => "${httpdMachine}",
    #     require => Package["httpd"],
        
    # }

    if "${httpToHttpsRedirectionEnabled}" == 'true' {
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

    # class { "httpd::httpToHttpsRedirection" :
    #     enabled => "${httpToHttpsRedirectionEnabled}",
    #     require => Package["httpd"],
    #     notify => Service["httpd"],
    # }

    if "${httpInternalPortRedirectionEnabled}" == 'true' {
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

    # class { "httpd::httpInternalPortRedirection" :
    #     enabled => "${httpInternalPortRedirectionEnabled}",
    #     require => Package["httpd"],
    #     notify => Service["httpd"],
    # }

    service {"httpd" :
        ensure => "running",
        enable => true,
        require => Package["httpd"],
    }
}
