class postgres ( $postgresUser, $postgresPassword, $postgresMachine, $postgresMaster, $postgresSlave, $os, $wordsize, $changeDefaultEncodingToUTF8, $postgresTimeZone = "",$pgPackVersion="91",$postgresVersion = "9.1") {

    $allPacks = [ "postgresql${pgPackVersion}", "postgresql${pgPackVersion}-server", "postgresql${pgPackVersion}-libs", "postgresql${pgPackVersion}-contrib", "postgresql${pgPackVersion}-devel"]


    if $postgresVersion == "9.3" {
      $rpmVersion = "9.3-1"
    }else{
      $rpmVersion = "9.1-4"
    }


    file{"/tmp/postgres-repo.rpm" :
        ensure      => present,
        source      => "puppet:///modules/postgres/pgdg-${os}-${rpmVersion}-${wordsize}.noarch.rpm",
    }

    exec { "run_postgres_repo" :
        provider    => "shell",
        command     => "rpm -i /tmp/postgres-repo.rpm",
        creates     => "/etc/yum.repos.d/pgdg-${pgPackVersion}-centos.repo",
        require     => File["/tmp/postgres-repo.rpm"],
        onlyif      => "test `rpm -qa postgres | wc -l` -eq 0",
    }

    package { "postgres_packs" :
        name        => $allPacks,
        ensure      => "present",
        require     => Exec["run_postgres_repo"],
    }

    user { "${postgresUser}" :
        ensure      => present,
        shell       => "/bin/bash",
        home        => "/home/$postgresUser",
        password    => $postgresPassword,
        require     => Exec["run_postgres_repo"],
        managehome => true,
    }

    file { "/etc/init.d/postgresql-${postgresVersion}" :
            ensure      => present,
            content     => template("postgres/postgres-init.d"),
            mode        =>  777,
            group       => "root",
            owner       => "root",
            require     => Package["postgres_packs"],
    }


    file { "/usr/local/pgsql/" :
        ensure      => "directory",
        owner       => "${postgresUser}",
    }

    file { "/usr/local/pgsql/data":
        ensure      => "directory",
        require     => File["/usr/local/pgsql/"],
        owner       => "${postgresUser}",
    }

    exec { "initdb":
        command     => "/usr/pgsql-${postgresVersion}/bin/initdb -D /usr/local/pgsql/data",
        user        => "${postgresUser}",
        require     => [File["/usr/local/pgsql/data"], Package["postgres_packs"]],
        provider    => "shell",
        onlyif      => "test ! -f /usr/local/pgsql/data/PG_VERSION",
    }

    exec { "start-server":
        command     => "/usr/pgsql-${postgresVersion}/bin/postgres -D /usr/local/pgsql/data &",
        user        => "${postgresUser}",
        require     => [Exec["initdb"], Exec["add_to_path"]],
    }

    if $changeDefaultEncodingToUTF8 == "true" {
        exec { "postgres-utf8-encoding":
            command     => "/usr/pgsql-${postgresVersion}/bin/psql -U ${postgresUser} < /tmp/postgres-utf8-encoding.sql",
            user        => "${motechUser}",
            require     => File["/tmp/postgres-utf8-encoding.sql"]
        }

        file { "/tmp/postgres-utf8-encoding.sql" :
            require     => Exec["start-server"],
            content     => template("postgres/postgres-utf8-encoding.sql"),
            owner       => "${motechUser}",
            group       => "${motechUser}",
            mode        =>  764
        }
    }

    file { "/etc/init.d/postgresql":
        ensure      => "link",
        target      => "/etc/init.d/postgresql-${postgresVersion}",
    }

    exec{"backup_conf":
        cwd         => "/usr/local/pgsql/data/",
        command     => "mv postgresql.conf postgresql.conf.backup && mv pg_hba.conf pg_hba.conf.backup",
        user        => "${postgresUser}",
        require     => Exec["start-server"],
    }

    exec{"add_to_path":
        command     => "echo \"export PATH=\$PATH:/usr/pgsql-${postgresVersion}/bin/\" > /etc/profile.d/repmgr.sh && source /etc/profile.d/repmgr.sh",
        require     => Package["postgres_packs"],
        onlyif      => "test ! -f  /etc/profile.d/repmgr.sh",
    }

    case $postgresMachine {

        master:{
            file {"/usr/local/pgsql/data/pg_hba.conf":
                content     => template("postgres/master_pg_hba.erb"),
                owner       => "${postgresUser}",
                group       => "${postgresUser}",
                mode        => 600,
                require     => Exec["backup_conf"],
            }

            file {"/usr/local/pgsql/data/postgresql.conf":
                content     => template("postgres/master_postgresql.erb"),
                owner       => "${postgresUser}",
                group       => "${postgresUser}",
                mode        => 600,
                require     => Exec["backup_conf"],
            }
        }

        slave:{
            file {"/usr/local/pgsql/data/pg_hba.conf":
                content     => template("postgres/slave_pg_hba.erb"),
                owner       => "${postgresUser}",
                group       => "${postgresUser}",
                mode        => 600,
                require     => Exec["backup_conf"],
            }

            file {"/usr/local/pgsql/data/postgresql.conf":
                content     => template("postgres/slave_postgresql.erb"),
                owner       => "${postgresUser}",
                group       => "${postgresUser}",
                mode        => 600,
                require     => Exec["backup_conf"],
            }
            
            file {"/usr/local/pgsql/data/recovery.conf":
                content     => template("postgres/slave_recovery.erb"),
                owner       => "${postgresUser}",
                group       => "${postgresUser}",
                mode        => 600,
                require     => Exec["backup_conf"],
            }
        }
    }
}
