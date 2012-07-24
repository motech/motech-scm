class birt {
  include users
  
  exec {"getbirttarfile" :
  	command => "/usr/bin/wget -O /tmp/birt-runtime-2_5_2.zip http://motechrepo.github.com/pub/motech/other/birt-runtime-2_5_2.zip",
  	require => [Exec["${motechUser} homedir"]]
  }
  
  exec { "birt_untar":
    command => "unzip /tmp/birt-runtime-2_5_2.zip",
    user => "${motechUser}",
    cwd     => "/home/${motechUser}/",
    creates => "/home/${motechUser}/",
    path    => ["/bin"],
    require => Exec["getbirttarfile"],
  }
}
