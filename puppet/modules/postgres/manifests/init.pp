class postgres ( $postgresUser, $postgresUserPassword, $postgresDBPassword, $postgresMachine, $postgresMaster, $postgresSlave, $os, $wordsize, $changeDefaultEncodingToUTF8, $postgresTimeZone = "",$pgPackVersion="91",$postgresMajorVersion = "9.1") {

    $allPacks = [ "postgresql${pgPackVersion}", "postgresql${pgPackVersion}-server", "postgresql${pgPackVersion}-libs", "postgresql${pgPackVersion}-contrib", "postgresql${pgPackVersion}-devel"]


    if $postgresMajorVersion == "9.3" {
      $rpmVersion = "9.3-1"
      $postgresVersion = "9.3.1"
    }else{
      $rpmVersion = "9.1-4"
      $postgresVersion = "9.1.4"
    }

    $pg_dir = "/usr/local/pgsql-${postgresMajorVersion}"
    $pg_data_dir = "${pg_dir}/data"
    $pg_log_dir = "${pg_data_dir}/pg_log/"

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
        password    => $postgresUserPassword,
        require     => Exec["run_postgres_repo"],
        managehome => true,
    }

    file { "/etc/init.d/postgresql-${$postgresMajorVersion}" :
            ensure      => present,
            content     => template("postgres/postgres-init.d"),
            mode        =>  777,
            group       => "root",
            owner       => "root",
            require     => Package["postgres_packs"],
    }


    file { "${pg_dir}" :
        ensure      => "directory",
        owner       => "${postgresUser}",
    }

    file { "${pg_data_dir}":
        ensure      => "directory",
        require     => File["${pg_dir}"],
        owner       => "${postgresUser}",
    }

    exec { "initdb":
        command     => "/usr/pgsql-${$postgresMajorVersion}/bin/initdb -D ${pg_data_dir}",
        user        => "${postgresUser}",
        require     => [File["${pg_data_dir}"], Package["postgres_packs"]],
        provider    => "shell",
        onlyif      => "test ! -f ${pg_data_dir}/PG_VERSION",
    }

    file { "${pg_log_dir}":
       ensure  => "directory",
       owner       => "${postgresUser}",
      require     => Exec["initdb"],
    }

    service { "postgresql":
      ensure      => running,
      require     => [Exec["initdb"], Exec["add_to_path"], File["/etc/init.d/postgresql"]],
    }

    if $changeDefaultEncodingToUTF8 == "true" {
        exec { "postgres-utf8-encoding":
            command     => "/usr/pgsql-${$postgresMajorVersion}/bin/psql -U ${postgresUser} < /tmp/postgres-utf8-encoding.sql",
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
        target      => "/etc/init.d/postgresql-${$postgresMajorVersion}",
    }

    exec{"backup_conf":
        cwd         => "${pg_data_dir}",
        command     => "mv postgresql.conf postgresql.conf.backup && mv pg_hba.conf pg_hba.conf.backup",
        user        => "${postgresUser}",
        require     => Service["postgresql"],
    }

    exec{"add_to_path":
        command     => "echo \"export PATH=\$PATH:/usr/pgsql-${$postgresMajorVersion}/bin/\" > /etc/profile.d/repmgr.sh && source /etc/profile.d/repmgr.sh",
        require     => Package["postgres_packs"],
        onlyif      => "test ! -f  /etc/profile.d/repmgr.sh",
    }

    exec{"alter_user_password":
        command     => "psql -c \"ALTER ROLE ${postgresUser} with PASSWORD '${postgresDBPassword}'\" --username=${postgresUser} --dbname=postgres",
        user        => "${postgresUser}",
        require     => [Exec["initdb"], Exec["add_to_path"], Service["postgresql"]],
        onlyif      => "psql -c "" -w",
    }

    case $postgresMachine {

        master:{
            file {"${pg_data_dir}/pg_hba.conf":
                content     => template("postgres/master_pg_hba.erb"),
                owner       => "${postgresUser}",
                group       => "${postgresUser}",
                mode        => 600,
                require     => Exec["backup_conf"],
            }

            file {"${pg_data_dir}/postgresql.conf":
                content     => template("postgres/master_postgresql.erb"),
                owner       => "${postgresUser}",
                group       => "${postgresUser}",
                mode        => 600,
                require     => Exec["backup_conf"],
            }
        }

        slave:{
            file {"${pg_data_dir}/pg_hba.conf":
                content     => template("postgres/slave_pg_hba.erb"),
                owner       => "${postgresUser}",
                group       => "${postgresUser}",
                mode        => 600,
                require     => Exec["backup_conf"],
            }

            file {"${pg_data_dir}/postgresql.conf":
                content     => template("postgres/slave_postgresql.erb"),
                owner       => "${postgresUser}",
                group       => "${postgresUser}",
                mode        => 600,
                require     => Exec["backup_conf"],
            }
            
            file {"${pg_data_dir}/recovery.conf":
                content     => template("postgres/slave_recovery.erb"),
                owner       => "${postgresUser}",
                group       => "${postgresUser}",
                mode        => 600,
                require     => Exec["backup_conf"],
            }
        }
    }

    exec{"restart_server":
            command     => "service postgresql restart",
            require     => [File["${pg_data_dir}/pg_hba.conf"],File["${pg_data_dir}/postgresql.conf"]],
        }


}
