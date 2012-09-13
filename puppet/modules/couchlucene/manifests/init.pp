class couchlucene ($version) {

    exec { "get_couch_lucene_tar" :
        command     => "/usr/bin/wget -O /tmp/couch-lucene.tar.gz http://dl.dropbox.com/u/102967387/couchdb-lucene-0.9.0-SNAPSHOT-dist.tar.gz",
        timeout     => 0,
        provider    => "shell",
        onlyif      => "test ! -f /tmp/couch-lucene.tar.gz"
    }


    exec { "couch_lucene_untar" :
        command     => "tar xfz /tmp/couch-lucene.tar.gz",
        user        => "${motechUser}",
        cwd         => "/home/${motechUser}",
        creates     => "/home/${motechUser}/couch-lucene",
        path        => ["/bin",],
        require     => [Exec["${motechUser} homedir"], Exec["get_couch_lucene_tar"]],
        provider    => "shell",
        onlyif      => "test ! -d /home/${motechUser}/couch-lucene"
    }

    file { "/etc/init.d/couch_lucene" :
        ensure      => present,
        content     => template("couchlucene/couchlucene-init.d"),
        mode        =>  777,
        group       => "root",
        owner       => "root",
        require     => Exec["couch_lucene_untar"],
    }

    define replace($file, $pattern, $replacement) {
    	$pattern_no_slashes = slash_escape($pattern)
    	$replacement_no_slashes = slash_escape($replacement)

    	exec { "/usr/bin/perl -pi -e 's/$pattern_no_slashes/$replacement_no_slashes/' '$file'":
    	    onlyif => "/usr/bin/perl -ne 'BEGIN { \$ret = 1; } \$ret = 0 if /$pattern_no_slashes/ && ! /$replacement_no_slashes/ ; END { exit \$ret; }' '$file'",
    	}
    }

    replace { "append_http_global_handlers":
	file => "/etc/couchdb/local.ini",
        pattern => "[httpd_global_handlers]",
	replacement => "[httpd_global_handlers]\n _fti = {couch_httpd_proxy, handle_proxy_req, <<\"http://127.0.0.1:5985\">>}",
	before => Service["couch_lucene"],
	require => Package["couchdb"],
	notify => Service["couchdb"],
    }

    exec { "install_couch_lucene_service" :
        command     => "/sbin/chkconfig --add couch_lucene",
        user        => "root",
        require     => File["/etc/init.d/couch_lucene"],
        onlyif      => "chkconfig --list couch_lucene; [ $? -eq 1 ]"
    }

    service { "couch_lucene":
        ensure     => running,
        path       => "/home/${motechUser}/couch-lucene/bin/run",
        enable     => true,
        require    => Exec["install_couch_lucene_service"],
    }
}
