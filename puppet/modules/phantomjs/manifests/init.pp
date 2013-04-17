class phantomjs() {

    file { "/tmp/phantomjs-1.9.0-linux-x86_64.tar.bz2" :
        source => "puppet:///modules/phantomjs/phantomjs-1.9.0-linux-x86_64.tar.bz2",
        ensure => "present",
    }

    exec { "createSymbolicLink":
        cwd => "/usr/local/bin",
        command => "ln -s /usr/local/phantomjs-1.9.0-linux-x86_64/bin/phantomjs phantomjs",
        require => Exec["install-phantomjs"],
    }

    exec { "install-phantomjs" :
        cwd => "/usr/local",
        command => "tar -xvf /tmp/phantomjs-1.9.0-linux-x86_64.tar.bz2",
        require => File["/tmp/phantomjs-1.9.0-linux-x86_64.tar.bz2"],
    }
}
