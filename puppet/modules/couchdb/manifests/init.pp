class couchdb  ($couchMaster, $couchDbs, $couchMachine, $couchVersion ) {
  include repos::epel
  include repos::motech

  package { "couchdb":
    ensure  =>  "${couchVersion}",
    require => [
      Package["epel-release.noarch"],
      Yumrepo["motech"]
      ],
  }

  service { "couchdb":
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require => Package["couchdb"],
  }

  if $couchVersion >= "1.2.0-7.el6" {
    file {"/home/${motechUser}/start-replication.sh" :
              require => Service["couchdb"],
              content => template("couchdb/start-replication.sh"),
              owner => "${motechUser}",
              group => "${motechUser}",
              mode   =>  764,
          }

    exec { "start_replication":
          require => File["/home/${motechUser}/start-replication.sh"],
          command =>  "/bin/sh /home/${motechUser}/start-replication.sh ${couchDbs} ${couchMaster}",
    }

    exec {"delete-scripts" :
             require => Exec["start_replication"],
             command => "rm -rf /home/${motechUser}/start-replication.sh"
             }

  } else {

    if $couchMachine == 'slave' {

      file {"/home/${motechUser}/couch-slave.sh" :
          content => template("couchdb/couch-slave.sh"),
          owner => "${motechUser}",
          group => "${motechUser}",
          mode   =>  764,
      }

      exec {"run_slave_script":
          require => File["/home/${motechUser}/couch-slave.sh"],
          command =>  "/home/${motechUser}/couch-slave.sh",
      }

    }
  }

}
