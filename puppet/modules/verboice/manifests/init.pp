class verboice {
include repos::motech

    file { '/tmp/configure_verboice.py':
        ensure => present,
        source => 'puppet:///modules/verboice/configure_verboice.py',
        mode => 777
    }

	exec { "/usr/bin/yum -y install Verboice" :
		environment => "MYSQL_PASSWORD=$mysqlPassword",
		require => [Yumrepo["motech"], Exec["setmysqlpassword"], Package["sox"], Package["libxslt"]],
		timeout => 0,
		logoutput => true
	}
	
	package { "sox":
		ensure => present
	}
	
	package { "libxslt":
		ensure => present
	}
	
	package { "monit" :
		ensure => present
	}
	
	service { "monit":
		ensure => running,
		enable => true,
		require =>Package["monit"]
	}

	exec { "monit -g verboice start all":
		require => [Exec["/usr/bin/yum -y install Verboice"], Service["monit"]],
	}

    exec { "/tmp/configure_verboice.py" :
        require => [File['/tmp/configure_verboice.py'], Exec['monit -g verboice start all']],
        logoutput => true
    }
}