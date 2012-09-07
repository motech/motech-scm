Exec {
  path => "/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin"
}

group { "puppet":
  ensure => "present",
}

### your config will go after here ##

