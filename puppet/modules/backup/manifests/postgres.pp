class backup::postgres($database = "whp",$user = "postgres" ,$password = "passwd"){

  require backup

  file { "/home/backups/postgres" :
     ensure => "directory",
     owner  => root,
     group  => root,
     mode   => 700,
  }

  file { "/home/backups/scripts/pg_backup.sh":
     ensure => present,
     content => template("backup/pg_backup.erb"),
     owner  => root,
     group  => root,
     mode   => 744,
     require => File["/home/backups/scripts"]
  }

  cron { "mtraining-postgres-backup":
    command => "/home/backups/scripts/pg_backup.sh ${user} ${database}",
    user    => root,
    hour    => [0,8,16],
    require => File["/home/backups/scripts/pg_backup.sh"]
  }

}