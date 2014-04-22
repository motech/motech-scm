class backup{

  file { ["/home/backups","/home/backups/scripts"] :
    ensure => "directory",
    owner  => root,
    group  => root,
    mode   => 700,
  }

}