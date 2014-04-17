class maven ( $version ){
  exec {"getmaventarfile" :
  	command => "/usr/bin/wget -O /tmp/maven.tar.gz http://archive.apache.org/dist/maven/binaries/apache-maven-${version}-bin.tar.gz",
    user    => "${motechUser}",
    timeout => 0,
    provider => "shell",
    require => [User["${motechUser}"]],
    onlyif  => "test ! -d /home/${motechUser}/apache-maven-${version}",
   }
	
  exec { "maven_untar" :
    command => "tar xfz /tmp/maven.tar.gz",
    user    => "${motechUser}",
    cwd     => "/home/${motechUser}",
    creates => "/home/${motechUser}/apache-maven-${version}",
    path    => ["/bin"],
    provider => "shell",
    require => [Exec["${motechUser} homedir", "getmaventarfile"]],
    onlyif  => "test ! -d /home/${motechUser}/apache-maven-${version}"
  }

  file {"/usr/local/bin/mvn" :
      ensure => link,
      target => "/home/${motechUser}/apache-maven-${version}/bin/mvn",
      owner =>  "${motechUser}",
      group => "${motechUser}",
      require => Exec["maven_untar"],
  }
}