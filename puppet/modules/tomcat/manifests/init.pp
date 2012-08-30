class tomcat ( $version, $userName ){

  exec {"gettomcattarfile" :
    command => "/usr/bin/wget -O /tmp/apache-tomcat-${version}.tar.gz http://motechrepo.github.com/pub/motech/other/apache-tomcat-${version}.tar.gz",
    require => [User["${userName}"]],
    timeout => 0
  }
  
  exec { "tomcat_untar":
    command => "tar xfz /tmp/apache-tomcat-${version}.tar.gz",
    user => "${userName}",
    cwd     => "/home/${userName}",
    creates => "/home/${userName}/apache-tomcat-${version}",
    path    => ["/bin"],
    require => Exec["gettomcattarfile"],
  }

  file { "/etc/init.d/tomcat" :
    content => template("tomcat/tomcat.initd"),
    mode   =>  777,
    group  => "root",
    owner  => "root",
    require => Exec["tomcat_untar"],
  }

  exec { "installtomcatservice" :
    command => "/sbin/chkconfig --add tomcat",
    user => "root", 
    require => File["/etc/init.d/tomcat"],
  }
  
  service { "tomcat":
    ensure => running,
    enable => true,
    hasstatus => false,
    require => Exec["installtomcatservice"],
  }
}
