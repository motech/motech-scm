class couchdb  ($couchdbPackageName, $couchReplicationSourceMachine, $couchDbs, $couchInstallationMode, $couchVersion, $couchDatabaseDir, $couchBindAddress) {
    include repos::epel
    include repos::motech

    package { "${couchdbPackageName}":
        ensure      =>  "${couchVersion}",
        require     => [
          Package["epel-release.noarch"],
          Yumrepo["motech"]
          ],
    }

    service { "couchdb":
        ensure      => running,
        enable      => true,
        hasrestart  => true,
        hasstatus   => true,
        require     => File["/etc/sysconfig/couchdb"],
    }

    # setup Pull based replication
    if $couchInstallationMode == 'withReplication' {
        if $couchVersion >= "1.2.0" {
            file {"/home/${motechUser}/start-replication.sh" :
                require     => Service["couchdb"],
                content     => template("couchdb/start-replication-couchv1.2.sh"),
                owner       => "${motechUser}",
                group       => "${motechUser}",
                mode        =>  764,
            }
        } else {
            file {"/home/${motechUser}/start-replication.sh" :
                content     => template("couchdb/start-replication-couchv1.1.sh"),
                owner       => "${motechUser}",
                group       => "${motechUser}",
                mode        =>  764,
            }
        }

        exec { "start_replication":
            require     => File["/home/${motechUser}/start-replication.sh"],
            command     =>  "/bin/sh /home/${motechUser}/start-replication.sh",
        }

        exec { "delete-scripts" :
             require    => Exec["start_replication"],
             command    => "rm -rf /home/${motechUser}/start-replication.sh"
        }
    }

    file { "/etc/sysconfig/couchdb":
        content     => template("couchdb/couchdb-config.erb"),
        require     => File["$couchDatabaseDir"]
    }

    file { "$couchDatabaseDir":
        ensure      => "directory",
        require     => Package["${couchdbPackageName}"],
        group       => "couchdb",
        owner       => "couchdb",
    }

    if $couchVersion >= "1.2.0-7.el6" {
        file {"/etc/couchdb/default.ini" :
            require     => Package["${couchdbPackageName}"],
            content     => template("couchdb/default.ini.erb"),
            owner       => "couchdb",
        }
    }
}
