class couchdblucene ($version) {

   exec { "get_couchdb_lucene_tar" :
        command     => "/usr/bin/wget -O /tmp/couchdb-lucene.tar.gz http://motechrepo.github.com/pub/motech/other/couchdb-lucene-${version}-dist.tar.gz",
        timeout     => 0,
        provider    => "shell",
        onlyif      => "test ! -f /tmp/couchdb-lucene.tar.gz"
    }

    exec { "couchdb_lucene_untar" :
        command     => "tar xfz /tmp/couchdb-lucene.tar.gz",
        user        => "${motechUser}",
        cwd         => "/home/${motechUser}",
        path        => ["/bin",],
        require     => [Exec["${motechUser} homedir"], Exec["get_couchdb_lucene_tar"]],
        provider    => "shell",
    }

    exec { "couchdb_lucene_rename" :
        command     => "mv couchdb-lucene-${version} couchdb-lucene",
        cwd         => "/home/${motechUser}",
        user        => "${motechUser}",
        require     => [Exec["couchdb_lucene_untar"]],
        provider    => "shell",
    }


    file { "/etc/init.d/couchdb-lucene" :
        ensure      => present,
        content     => template("couchdblucene/couchdb-lucene-init.d"),
        mode        =>  777,
        group       => "root",
        owner       => "root",
        require     => Exec["couchdb_lucene_rename"],
    }

    exec { "install_couchdb_lucene_service" :
        command     => "/sbin/chkconfig --add couchdb-lucene",
        user        => "root",
        require     => File["/etc/init.d/couchdb-lucene"],
        onlyif      => "chkconfig --list couchdb-lucene; [ $? -eq 1 ]"
    }

    service { "couchdb-lucene":
        ensure     => running,
        path       => "/home/${motechUser}/couchdb-lucene/bin/run",
        enable     => true,
        require    => Exec["install_couchdb_lucene_service"],
    }
}
