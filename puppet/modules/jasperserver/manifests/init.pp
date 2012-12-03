class jasperserver () {

    exec {"get_jasperserver" :
            command     => "/usr/bin/wget -O /tmp/jasperserver.zip  'http://downloads.sourceforge.net/project/jasperserver/JasperServer/JasperReports%20Server%204.7.0/jasperreports-server-cp-4.7.0-bin.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fjasperserver%2Ffiles%2FJasperServer%2FJasperReports%2520Server%25204.7.0%2F&ts=1353928192&use_mirror=nchc'",
            timeout     => 0,
            provider    => "shell",
            onlyif      => "test ! -f /tmp/jasperserver.zip"
    }
    exec { "unzip_jasperserver":
            command     => "unzip -u /tmp/jasperserver.zip -d /tmp/jasperserver ",
            require     => Exec["get_jasperserver"],
            provider    => "shell",
            onlyif      => "test ! -f /tmp/jasperserver/jasperreports-server-cp-4.7.0-bin/buildomatic/default_master.properties"
    }
    file { "/tmp/jasperserver/jasperreports-server-cp-4.7.0-bin/buildomatic/default_master.properties" :
            content     => template("jasperserver/default_master.properties.erb"),
            require     => Exec['unzip_jasperserver'],
    }
    exec { "make_jasperserver" :
        command         => "echo ${jasperOverwriteDb} | /bin/sh /tmp/jasperserver/jasperreports-server-cp-4.7.0-bin/buildomatic/js-install-ce.sh minimal",
        require         => File["/tmp/jasperserver/jasperreports-server-cp-4.7.0-bin/buildomatic/default_master.properties"],
        cwd             => "/tmp/jasperserver/jasperreports-server-cp-4.7.0-bin/buildomatic",
    }
}
