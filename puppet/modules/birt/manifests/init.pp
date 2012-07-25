class birt {
  include users
  
  exec {"getbirttarfile" :
  	command => "/usr/bin/wget -O /tmp/birt-runtime-2_5_2.tar.gz https://github.com/downloads/motechrepo/motechrepo.github.com/birt-runtime-2_5_2.tar.gz",
  	require => [Exec["${motechUser} homedir"]]
  }
  
  exec { "birt_untar":
    command => "tar xfz /tmp/birt-runtime-2_5_2.tar.gz",
    user => "${motechUser}",
    cwd     => "/home/${motechUser}/",
    creates => "/home/${motechUser}/",
    path    => ["/bin"],
    require => Exec["getbirttarfile"],
  }
}
