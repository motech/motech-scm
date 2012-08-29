class repos::epel {
  file { "/tmp/get-latest-epel-rpm.sh" :
    ensure => present,
	mode   =>  764,
    source => "puppet:///modules/repos/get-latest-epel-rpm.sh",
  }

  exec { "get-latest-epel-rpm" :
  	command => "/bin/sh /tmp/get-latest-epel-rpm.sh",
  	require => File["/tmp/get-latest-epel-rpm.sh"],
  }

  package { "epel-release.noarch":
    provider => "rpm",
    ensure => "present",
    source => "/tmp/epel-release.rpm",
    require => Exec["get-latest-epel-rpm"]
  }
}
