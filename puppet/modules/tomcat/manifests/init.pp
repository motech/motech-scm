class tomcat ( $version, $userName, $tomcatManagerUserName, $tomcatManagerPassword, $tomcatInstance ) {

    exec {"gettomcattarfile" :
        command     => "/usr/bin/wget -O /tmp/apache-tomcat-${version}.tar.gz http://motechrepo.github.com/pub/motech/other/apache-tomcat-${version}.tar.gz",
        require     => [User["${userName}"]],
        timeout     => 0,
        provider    => "shell",
        onlyif      => "test ! -f /tmp/apache-tomcat-${version}.tar.gz"
    }

    $instanceSuffix = "-${tomcatInstance}"

    exec { "tomcat_untar":
        command     => "tar xfz /tmp/apache-tomcat-${version}.tar.gz;mv apache-tomcat-${version} apache-tomcat-${version}${instanceSuffix}",
        user        => "${userName}",
        cwd         => "/home/${userName}",
        creates     => "/home/${userName}/apache-tomcat-${version}${instanceSuffix}",
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
        require     => Exec["tomcat_untar"],
    }

    file { "/home/${userName}/apache-tomcat-${version}${instanceSuffix}/conf/server.xml" :
            ensure      => present,
            content     => template("tomcat/server.xml.erb"),
            group       => "${userName}",
            owner       => "${userName}",
            replace     => true,
            require     => File["/etc/init.d/tomcat${instanceSuffix}"],
    }

    file { "/home/${userName}/apache-tomcat-${version}${instanceSuffix}/conf/tomcat-users.xml" :
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
