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
        onlyif      => "test ! -d couchdb-lucene-${version}",
    }

    exec { "kill_exisiting_couchdb_lucene_processes" :
            onlyif      => ["test -f /etc/init.d/couchdb-lucene"],
            command     => "kill -9 `ps -ef | grep couchdb-lucene | grep -v grep | awk '{print $2}'`",
            provider    => "shell",
    }

    exec { "couchdb_lucene_rename" :
        command     => "mv couchdb-lucene-${version} couchdb-lucene",
        cwd         => "/home/${motechUser}",
        user        => "${motechUser}",
        require     => [Exec["couchdb_lucene_untar"]],
        provider    => "shell",
        onlyif      => "test ! -d couchdb-lucene",
    }

    file { "/home/${motechUser}/couchdb-lucene/conf/couchdb-lucene.ini" :
        ensure      => present,
        content     => template("couchdblucene/couchdb-lucene.ini"),
        mode        =>  777,
        group       => "${motechUser}",
        owner       => "${motechUser}",
        require     => Exec["couchdb_lucene_rename"],
    }

    define replace($file, $pattern, $replacement) {
        $pattern_no_slashes = regsubst($pattern, '/', '\\/', 'G', 'U')
        $replacement_no_slashes=$replacement
        exec {"replace_couch_conf" :
                    command => "/usr/bin/perl -pi -e 's/$pattern_no_slashes/$replacement_no_slashes/' '$file'",
        }
    }

    replace { "append_http_global_handlers":
        file => "/etc/couchdb/local.ini",
        pattern => "\[httpd_global_handlers\]",
        replacement => '\[httpd_global_handlers\] \n_fti = {couch_httpd_proxy, handle_proxy_req, <<"http:\/\/127.0.0.1:5985">>} ',
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
        require     => [File["/etc/init.d/couchdb-lucene"], Exec["kill_exisiting_couchdb_lucene_processes"]],
        onlyif      => "chkconfig --list couchdb-lucene; [ $? -eq 1 ]"
    }

    exec { "restart_couchdb" :
        command     => "service couchdb restart",
        user        => "root",
        require => Exec["install_couchdb_lucene_service"]
    }

    service { "couchdb-lucene":
        ensure     => running,
        path       => "/home/${motechUser}/couchdb-lucene/bin/run",
        enable     => true,
        require    => Exec["restart_couchdb"],
    }
}
