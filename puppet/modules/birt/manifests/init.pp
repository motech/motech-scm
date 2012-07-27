class birt {
  include users

  exec {"getbirttarfile" :
        command => "/usr/bin/wget -O /tmp/birt-runtime-2_5_2.tar.gz https://github.com/downloads/motechrepo/motechrepo.github.com/birt-runtime-2_5_2.tar.gz",
        require => [Exec["${motechUser} homedir"]],
        timeout => 0
  }

  exec { "birt_untar":
    command => "tar xfz /tmp/birt-runtime-2_5_2.tar.gz",
    user => "${motechUser}",
    cwd     => "/home/${motechUser}/",
    creates => "/home/${motechUser}/birt-runtime-2_5_2",
    path    => ["/bin"],
    require => Exec["getbirttarfile"],
  }

 file { "/home/${motechUser}/birt" :
    ensure => "link",
    target => "/home/${motechUser}/birt-runtime-2_5_2",
    require => Exec["birt_untar"]
  }
}