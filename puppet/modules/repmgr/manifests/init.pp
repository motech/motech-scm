class repmgr($postgresVersion, $repmgrVersion) {

    exec { "stop_postgres":
            command => "service postgresql stop",
    }

    package { "libxslt-devel" :
        ensure => "present",
    }

    package { "pam-devel" :
        ensure => "present",
    }

    exec { "getRepMgrTar" :
        command => "/usr/bin/wget -O /tmp/repmgr.tar.gz http://www.repmgr.org/download/repmgr-${repmgrVersion}.tar.gz",
        onlyif => "test ! -f /tmp/repmgr.tar.gz",
    }

    exec { "unTarRepMgr" :
        cwd => "/tmp",
        command => "tar -xvf /tmp/repmgr.tar.gz",
        require => Exec["getRepMgrTar"],
        onlyif => "test ! -d /tmp/repmgr",
    }

    exec { "install-repmgr" :
        cwd => "/tmp/repmgr-${repmgrVersion}",
        command => "make USE_PGXS=1 && make install USE_PGXS=1",
        require => [Exec["stop_postgres"], Exec["unTarRepMgr"], Package["libxslt-devel"], Package["pam-devel"]],
        path => "/bin/:/usr/bin/:/usr/pgsql-9.1/bin"
    }

    exec { "finalize-installation":
        require => Exec["install-repmgr"],
        command => "service postgresql start"
    }
}
