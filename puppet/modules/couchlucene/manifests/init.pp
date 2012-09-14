class couchdblucene ($version) {

 =begin
    exec { "get_couchdb_lucene_tar" :
        command     => "/usr/bin/wget -O /tmp/couchdb-lucene.tar.gz http://dl.dropbox.com/u/102967387/couchdb-lucene-0.9.0-SNAPSHOT-dist.tar.gz",
        timeout     => 0,
        provider    => "shell",
        onlyif      => "test ! -f /tmp/couchdb-lucene.tar.gz"
    }
=end

    exec { "couchdb_lucene_untar" :
        command     => "tar xfz /tmp/couchdb-lucene.tar.gz",
        user        => "${motechUser}",
        cwd         => "/usr/local",
        creates     => "/usr/local/couchdb-lucene",
        path        => ["/bin",],
        require     => [Exec["${motechUser} homedir"]],
        provider    => "shell",
        onlyif      => "test ! -d /usr/local/couchdb-lucene"
    }

    file { "/etc/init.d/couchdb-lucene" :
        ensure      => present,
        content     => template("couchdblucene/couchdb-lucene-init.d"),
        mode        =>  777,
        group       => "root",
        owner       => "root",
        require     => Exec["couchdb_lucene_untar"],
    }

    exec { "install_couchdb_lucene_service" :
        command     => "/sbin/chkconfig --add couchdb-lucene",
        user        => "root",
        require     => File["/etc/init.d/couchdb-lucene"],
        onlyif      => "chkconfig --list couchdb-lucene; [ $? -eq 1 ]"
    }

    service { "couchdb_lucene":
        ensure     => running,
        path       => "/usr/local/couchdb-lucene/bin/run",
        enable     => true,
        require    => Exec["install_couchdb_lucene_service"],
    }
}
