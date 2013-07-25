class activemq ( $version, $activemqMachine, $activemqMasterHost, $activemqMasterPort, $activemqDataDir, $memoryLimit = "1mb") {

    exec { "getactivemqtar" :
        command     => "/usr/bin/wget -O /tmp/activemq.tar.gz http://motechrepo.github.com/pub/motech/other/apache-activemq-${version}-bin.tar.gz",
        user        => "${motechUser}",
        timeout     => 0,
        provider    => "shell",
        onlyif      => "test ! -f /tmp/activemq.tar.gz"
    }


    exec { "activemq_untar" :
        command     => "tar xfz /tmp/activemq.tar.gz",
        user        => "${motechUser}",
        cwd         => "/home/${motechUser}",
        creates     => "/home/${motechUser}/apache-activemq-${version}",
        path        => ["/bin",],
        require     => [Exec["${motechUser} homedir"], Exec["getactivemqtar"]],
        provider    => "shell",
        onlyif      => "test ! -d /home/${motechUser}/apache-activemq-${version}"
    }

    file { "/etc/init.d/activemq" :
        ensure      => present,
        content     => template("activemq/activemq-init.d"),
        mode        =>  777,
        group       => "root",
        owner       => "root",
        require     => File["$activemqDataDir/data"],
    }

    file { "$activemqDataDir":
        ensure      => "directory",
        require     => Exec["activemq_untar"],
        group       => "${motechUser}",
        owner       => "${motechUser}",
    }

    file { "$activemqDataDir/data":
        ensure      => "directory",
        require     => File["$activemqDataDir"],
        group       => "${motechUser}",
        owner       => "${motechUser}",
    }
  
  if "${activemqMachine}" == 'slave' {

       exec { "activemq_backup_slave_conf" :
            cwd         => "/home/${motechUser}/apache-activemq-${version}/conf",
            command     => "mv activemq.xml activemq.xml.backup",
            user        => "${motechUser}",
            require     => Exec["activemq_untar"],
       }

       file { "/home/${motechUser}/apache-activemq-${version}/conf/activemq.xml":
           notify       => Service["activemq"],
           content      => template("activemq/activemq_slave.xml.erb"),
           owner        => "${motechUser}",
           group        => "${motechUser}",
           mode         => 644,
           require      => Exec["activemq_backup_slave_conf"],
       }
    }

   if "${activemqMachine}" == 'master' {

       file { "/home/${motechUser}/apache-activemq-${version}/conf/activemq.xml":
           notify       => Service["activemq"],
           content      => template("activemq/activemq_master.xml.erb"),
           owner        => "${motechUser}",
           group        => "${motechUser}",
           mode         => 644,
           require      => Exec["activemq_untar"]
       }
    }

    exec { "installservice" :
        command     => "/sbin/chkconfig --add activemq",
        user        => "root",
        require     => File["/etc/init.d/activemq"],
        onlyif      => "chkconfig --list activemq; [ $? -eq 1 ]"
    }

    service { "activemq":
        ensure     => running,
        path       => "/home/${motechUser}/apache-activemq-${version}/bin/activemq",
        enable     => true,
        require    => Exec["installservice"],
    }
}
