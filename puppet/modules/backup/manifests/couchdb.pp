class backup::couchdb($couchDataDir = "/var/lib/couchdb/", $couchConfDir = "/etc/couchdb/", $couchLogDir="/var/log/couchdb/"){

  require backup

  file { "/home/backups/couchdb" :
     ensure => "directory",
     owner  => root,
     group  => root,
     mode   => 700,
  }

  file { "/home/backups/scripts/couchdb_backup.sh":
     ensure => present,
     content => template("backup/couchdb_backup.erb"),
     owner  => root,
     group  => root,
     mode   => 744,
     require => File["/home/backups/scripts"]
  }

  cron { "mtraining-couchdb-backup":
    command => "/home/backups/scripts/couchdb_backup.sh",
    user    => root,
    minute  => 0,
    hour    => 0,
    require => File["/home/backups/scripts/couchdb_backup.sh"]
  }

}