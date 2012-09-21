# This class as of now ensures httpd installed and running
# Project specific rules need to be inserted manually into httpd.conf and ssl.conf

class httpd () { #($config_url, $config_path) {

    package { "httpd" :
        ensure => "present"
    }

    exec { "httpd_conf_backup" :
        cwd         => "/etc/httpd/conf",
        command     => "mv httpd.conf httpd.conf.bkup",
        require     => Package["httpd"],
    }

    file { "/etc/httpd/conf/httpd.conf":
       content      => template("httpd/httpd.conf.erb", "httpd/httpd.conf.redirects.erb"),
       require      => Exec["httpd_conf_backup"],
       notify       => Service["httpd"],
    }

    service {"httpd" :
        ensure      => "running",
        enable      => true,
        require     => Package["httpd"]
    }


    # file { "/tmp/httpd_package" :
    #     purge  => true,
    #     recurse => true,
    #     force => true,
    #     ensure  => "directory",
    #     require => Package["httpd"]
    # }

    # exec { "wget '${config_url}' -O config.jar" :
    #     alias   => "fetch_httpd_config_package",
    #     cwd     => "/tmp/httpd_package",
    #     require => File["/tmp/httpd_package"]
    # }

    # exec { "jar -xvf config.jar" :
    #     cwd     => "/tmp/httpd_package",
    #     alias   => "unjar_httpd_package",
    #     require => Exec["fetch_httpd_config_package"]
    # }

    # file { "/tmp/apply_conf_part.sh" :
    #     source => "puppet:///modules/httpd/apply_conf_part.sh"
    # }

    # file { "/tmp/httpd.conf.part" :
    #     source => "puppet:///modules/httpd/httpd.conf.part"
    # }

    # file { "/tmp/ssl.conf.part" :
    #     source => "puppet:///modules/httpd/ssl.conf.part"
    # }
    
    ###### httpd.conf ######
    ## take a backup
    # file { "/etc/httpd/conf/httpd.conf.bk" :
    #     source => "/etc/httpd/conf/httpd.conf",
    #     require => Package["httpd"]
    # }

    ## create a httpd.conf from default
    # file { "/etc/httpd/conf/httpd.conf" :
    #     source => "puppet:///modules/httpd/httpd.conf.default",
    #     require => File["/etc/httpd/conf/httpd.conf.bk"],
    #     notify => Service["httpd"]
    # }

    ## apply httpd.conf.part
    # exec { "sh /tmp/apply_conf_part.sh /tmp/httpd.conf.part /etc/httpd/conf/httpd.conf" :
    #     require => File["/tmp/httpd.conf.part", "/etc/httpd/conf/httpd.conf", "/etc/httpd/conf/httpd.conf.bk", "/tmp/apply_conf_part.sh"],
    #     alias => "apply_httpd_conf_part",
    #     notify => Service["httpd"]
    # }

    ###### ssl.conf ######
    ## take a backup
    # file { "/etc/httpd/conf.d/ssl.conf.bk" :
    #     source => "/etc/httpd/conf.d/ssl.conf",
    #     require => Package["httpd"]
    # }

    ## create a ssl.conf from default
    # file { "/etc/httpd/conf.d/ssl.conf" :
    #     source => "puppet:///modules/httpd/ssl.conf.default",
    #     require => File["/etc/httpd/conf.d/ssl.conf.bk"],
    #     notify => Service["httpd"]
    # }

    ## apply ssl.conf.part
    # exec { "sh /tmp/apply_conf_part.sh /tmp/ssl.conf.part /etc/httpd/conf.d/ssl.conf" :
    #     require => File["/tmp/ssl.conf.part", "/etc/httpd/conf.d/ssl.conf", "/etc/httpd/conf.d/ssl.conf.bk", "/tmp/apply_conf_part.sh"],
    #     alias => "apply_ssl_conf_part",
    #     notify => Service["httpd"]
    # }
}
