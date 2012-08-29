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