class tomcat ( $version, $userName, $tomcatManagerUserName = "", $tomcatManagerPassword = "", $tomcatInstance = "", $tomcatHttpPort = "8080", $tomcatRedirectPort = "8443", $tomcatShutdownPort = "8005", $tomcatAjpPort = "8009", $tomcatManagerRoles = [],$minHeapMemory="512m",$maxHeapMemory="4096m",$minPermgenSize="256m",$maxPermgenSize="512m",$javaSystemProperties="-Dlog.dir=/var/log/motech/") {

    exec {"gettomcattarfile" :
        command     => "/usr/bin/wget -O /tmp/apache-tomcat-${version}.tar.gz http://motechrepo.github.com/pub/motech/other/apache-tomcat-${version}.tar.gz",
        user        => "${userName}",
        require     => [User["${userName}"]],
        timeout     => 0,
        provider    => "shell",
        onlyif      => "test ! -f /tmp/apache-tomcat-${version}.tar.gz"
    }

    if $tomcatInstance != "" {
        $instanceSuffix = "-${tomcatInstance}"
    } else {
	    $instanceSuffix = ""
    }

    $tomcatInstallationDirectory = "/home/${userName}/apache-tomcat-${version}${instanceSuffix}"

    $moveAfterExtractCommand = "mv apache-tomcat-${version} ${tomcatInstallationDirectory}"

    exec { "move_tomcat":
       command =>  "mv apache-tomcat-${version} ${tomcatInstallationDirectory}",
       user        => "${userName}",
       cwd         => "/tmp/",
       creates     => "$tomcatInstallationDirectory",
       path        => ["/bin"],
       require     =>  Exec["tomcat_untar"]
    }

    exec { "tomcat_untar":
        command     => "tar -zxf /tmp/apache-tomcat-${version}.tar.gz",
        user        => "${userName}",
        cwd         => "/tmp/",
        path        => ["/bin"],
        require     => [Exec["$userName homedir"], Exec["gettomcattarfile"]],
        provider    => "shell",
    }

    file { "/etc/init.d/tomcat${$instanceSuffix}" :
        ensure      => present,
        content     => template("tomcat/tomcat.initd"),
        mode        => 777,
        group       => "root",
        owner       => "root",
        require     => Exec["move_tomcat"],
    }

    file { "$tomcatInstallationDirectory/conf/server.xml" :
        ensure      => present,
        content     => template("tomcat/server.xml.erb"),
        group       => "${userName}",
        owner       => "${userName}",
        replace     => true,
        require     => File["/etc/init.d/tomcat${instanceSuffix}"],
    }

    file { "$tomcatInstallationDirectory/bin/catalina.sh" :
            ensure      => present,
            content     => template("tomcat/catalina.sh.erb"),
            group       => "${userName}",
            owner       => "${userName}",
            mode        => 755,
            require     => [File["/etc/init.d/tomcat${instanceSuffix}"],File["/var/log/motech"]],
    }

    file { "/var/log/motech" :
            ensure  => directory,
            group       => "${userName}",
            owner       => "${userName}",
            mode    => '0755',
    }


    file { "$tomcatInstallationDirectory/conf/tomcat-users.xml" :
        ensure      => present,
        content     => template("tomcat/tomcat-users.xml.erb"),
        group       => "${userName}",
        owner       => "${userName}",
        require     => File["/etc/init.d/tomcat${instanceSuffix}"],
    }

    exec { "installtomcatservice" :
        provider    => "shell",
        user        => "root",
        command     => "/sbin/chkconfig --add tomcat${instanceSuffix}",
        require     => File["/etc/init.d/tomcat${instanceSuffix}"],
        onlyif      => "chkconfig --list tomcat${instanceSuffix}; [ $? -eq 1 ]"
    }

    service { "tomcat${instanceSuffix}" :
        ensure      => running,
        enable      => true,
        hasstatus   => false,
        require     => Exec["installtomcatservice"],
    }
}
