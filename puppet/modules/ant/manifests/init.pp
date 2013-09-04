class ant ( $version = "1.8.2" ){
  exec {"getanttarfile" :
    command => "/usr/bin/wget -O /tmp/ant.tar.gz http://archive.apache.org/dist/ant/binaries/apache-ant-${version}-bin.tar.gz",
    user    => "${motechUser}",
    timeout => 0,
    provider => "shell",
    require => [User["${motechUser}"]],
    onlyif  => "test ! -d /home/${motechUser}/apache-ant-${version}",
   }
	
  exec { "ant_untar" :
    command => "tar xfz /tmp/ant.tar.gz",
    user    => "${motechUser}",
    cwd     => "/home/${motechUser}",
    creates => "/home/${motechUser}/apache-ant-${version}",
    path    => ["/bin",],
    require => [Exec["$userName homedir", "getanttarfile"]],
    onlyif  => "test ! -d /home/${motechUser}/apache-ant-${version}"
  }
}