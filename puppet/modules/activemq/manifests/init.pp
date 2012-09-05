class activemq ( $version, $activemqMachine, $activemqMasterHost, $activemqMasterPort ) {

  exec { "getactivemqtar":
    command => "/usr/bin/wget -O /tmp/activemq.tar.gz http://motechrepo.github.com/pub/motech/other/apache-activemq-${version}-bin.tar.gz",
    timeout => 0
  }


  exec { "activemq_untar":
    command => "tar xfz /tmp/activemq.tar.gz",
    user => "${motechUser}",
    cwd     => "/home/${motechUser}",
    creates => "/home/${motechUser}/apache-activemq-${version}",
    path    => ["/bin",],
    require => [Exec["${motechUser} homedir"], Exec["getactivemqtar"]],
  }

  file { "/etc/init.d/activemq" :
    content => template("activemq/activemq-init.d"),
    mode   =>  777,
    group  => "root",
    owner  => "root",
    require => Exec["activemq_untar"],
  }
  
  if "${activemqMachine}" == 'slave' {
       exec {
            "activemq_backup_slave_conf":
                cwd     => "/home/${motechUser}/apache-activemq-${version}/conf",
                command => "mv activemq.xml activemq.xml.backup",
                user    => "${motechUser}",
                require => Exec["activemq_untar"],
       }

       file { "/home/${motechUser}/apache-activemq-${version}/conf/activemq.xml":
           notify => Service["activemq"],
           content => template("activemq/activemq_slave.xml.erb"),
           owner => "${motechUser}",
           group => "${motechUser}",
           mode   =>  644,
           require => Exec["activemq_backup_slave_conf"],
       }
    }

  exec { "installservice" :
    command => "/sbin/chkconfig --add activemq",
    user => "root",
    require => File["/etc/init.d/activemq"],
  }

  service { "activemq":
    path       => "/home/${motechUser}/apache-activemq-${version}/bin/activemq",
    ensure     => running,
    enable     => true,
    require => Exec["installservice"],
  }
}
