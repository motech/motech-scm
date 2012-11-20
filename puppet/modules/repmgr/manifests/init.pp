class repmgr($postgresVersion) {

    exec { "stop_postgres":
            command => "service postgresql stop",
    }

    exec { "start_postgres":
            command => "service postgresql start",
    }

    pacakge { "libxslt-devel" :
        ensure => "present",
    }

    pacakge { "pam-devel" :
        ensure => "present",
    }

    exec { "getRepMgrTar" :
        command => "/usr/bin/wget -O /tmp/repmgr.tar.gz http://www.repmgr.org/download/repmgr-1.2.0.tar.gz",
        onlyif => "test ! -f /tmp/repmgr.tar.gz",
    }

    exec { "unTarRepMgr" :
        cwd => "/tmp"
        command => "tar -xvf /tmp/repmgr.tar.gz",
        require => Exec["getRepMgrTar"],
        onlyif => "test ! -d /tmp/repmgr",
    }

    exec { "install-repmgr" :
        cwd => "/tmp/repmgr",
        command => "make USE_PGXS=1 & make install USE_PGXS=1",
        require => [Exec["stop_postgres"], Exec["unTarRepMgr"], Package["libxslt-devel"], Package["pam-devel"]],
        user    => "postgres"
    }

    exec { "finalize-installation":
        require => [Exec["install-repmgr"], Exec["start_postgres"]],
    }
}
