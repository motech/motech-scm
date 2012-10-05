class tomcat ( $version, $userName, $tomcatManagerUserName, $tomcatManagerPassword ) {

    exec {"gettomcattarfile" :
        command     => "/usr/bin/wget -O /tmp/apache-tomcat-${version}.tar.gz http://motechrepo.github.com/pub/motech/other/apache-tomcat-${version}.tar.gz",
        require     => [User["${userName}"]],
        timeout     => 0,
        provider    => "shell",
        onlyif      => "test ! -f /tmp/apache-tomcat-${version}.tar.gz"
    }

    exec { "tomcat_untar":
        command     => "tar xfz /tmp/apache-tomcat-${version}.tar.gz",
        user        => "${userName}",
        cwd         => "/home/${userName}",
        creates     => "/home/${userName}/apache-tomcat-${version}",
        path        => ["/bin"],
        require     => Exec["gettomcattarfile"],
        provider    => "shell",
        onlyif      => "test ! -f /home/${userName}/apache-tomcat-${version}"
    }

    file { "/etc/init.d/tomcat" :
        ensure      => present,
        content     => template("tomcat/tomcat.initd"),
        mode        => 777,
        group       => "root",
        owner       => "root",
        require     => Exec["tomcat_untar"],
    }

    file { "/home/${userName}/apache-tomcat-${version}/conf/tomcat-users.xml" :
        ensure      => present,
        content     => template("tomcat/tomcat-users.xml.erb"),
        group       => "${userName}",
        owner       => "${userName}",
        require     => File["/etc/init.d/tomcat"]
    }

    exec { "installtomcatservice" :
        provider    => "shell",
        user        => "root",
        command     => "/sbin/chkconfig --add tomcat",
        require     => File["/etc/init.d/tomcat"],
        onlyif      => "chkconfig --list tomcat; [ $? -eq 1 ]"
    }

    service { "tomcat" :
        ensure      => running,
        enable      => true,
        hasstatus   => false,
        require     => Exec["installtomcatservice"],
    }
}
