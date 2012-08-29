
class httpd ( $userName, $httpdMachine, $httpdProxyPort, $httpdMasterHost, $httpdMasterPort, $httpdSlaveHost, $httpdSlavePort, $httpToHttpsRedirectionEnabled, $httpInternalPortRedirectionEnabled, $httpsExcludedHostAddress, $apacheHttpPort, $httpSslPort, $apacheTomcatPort) {
    package { "httpd" :
        ensure => "present",
    }

    class { "httpd::failoverProxy" :
        httpdMachine => "${httpdMachine}",
        require => Package["httpd"],
        notify => Service["httpd"],
    }

    class { "httpd::httpToHttpsRedirection" :
        enabled => "${httpToHttpsRedirectionEnabled}",
        require => Package["httpd"],
        notify => Service["httpd"],
    }

    class { "httpd::httpInternalPortRedirection" :
        enabled => "${httpInternalPortRedirectionEnabled}",
        require => Package["httpd"],
        notify => Service["httpd"],
    }

    service {"httpd" :
        ensure => "running",
        enable => true,
        require => Package["httpd"],
    }
}
