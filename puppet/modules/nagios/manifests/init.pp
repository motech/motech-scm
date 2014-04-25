    class nagios ($nagios_config_url, $nagios_objects_path, $nagios_plugins_path, $host_file_path , $nrpe_config_path) {

    package { "nagios" :
        ensure  =>  "present"
    }

    package { "nagios-plugins-all" :
        ensure  => "present",
        require => Package["nagios"]
    }

    package { "nrpe" :
        ensure  => "present",
        require => Package["nagios-plugins-all"]
    }

    service { "nrpe":
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        require => Package["nrpe"]
    }


    package { "nagios-plugins-nrpe" :
        ensure  => "present",
        require => Service["nrpe"]
    }

    # This package is required for the check_activemq plugin to run
    package { "perl-libwww-perl" :
        ensure  => "present",
        require => Package["nagios-plugins-all"]
    }

    package { "perl-Time-HiRes" :
        ensure  => "present",
        require => Package["perl-libwww-perl"]
    }

    file { "/tmp/nagios_package" :
        ensure  => "directory",
        require => Package["perl-Time-HiRes"]
    }

    exec { "wget '${nagios_config_url}' -O nagios_repo.jar" :
        alias   => "fetch_nagios_config_package",
        cwd     => "/tmp/nagios_package",
        require => File["/tmp/nagios_package"]
    }

    exec { "jar -xvf nagios_repo.jar" :
        cwd     => "/tmp/nagios_package",
        alias   => "unjar_nagios_package",
        require => Exec["fetch_nagios_config_package"]
    }

    file { "/etc/nagios/objects/":
      source    => "/tmp/nagios_package/${nagios_objects_path}",
      recurse   => true,
      owner =>     "nagios",
      group =>     "nagios",
      purge     => true,
      require   => Exec["unjar_nagios_package"]
    }

    file { "/etc/nagios/objects/hosts.cfg":
      source    => "/tmp/nagios_package/${host_file_path}",
      owner =>     "nagios",
      group =>     "nagios",
      require   => [File["/etc/nagios/objects/"],File["/etc/nagios/nagios.cfg"]]
    }

    file { "/etc/nagios/nrpe.cfg":
      source    => "/tmp/nagios_package/${nrpe_config_path}",
      owner =>     "nagios",
      group =>     "nagios",
      require   => File["/etc/nagios/objects/"]
    }

    file { "/etc/nagios/nagios.cfg":
      source    => "puppet:///modules/nagios/nagios.conf",
      require   => File["/etc/nagios/objects/"],
      owner =>     "nagios",
      group =>     "nagios",
    }

    file { "/usr/lib64/nagios/plugins/":
      source    => "/tmp/nagios_package/${nagios_plugins_path}",
      recurse   => true,
      owner => "nagios",
      group => "nagios",
      mode      =>  554,
      require   => File["/etc/nagios/objects/hosts.cfg"]
    }

    file { "/etc/httpd/conf.d/nagios.conf":
      source    => "puppet:///modules/nagios/httpd/nagios.conf",
      ensure    => present,
      owner => root,
      group => root,
      require   => File["/etc/nagios/passwd"],
      notify    => Service["httpd"]
    }

    file { "/etc/nagios/private/resource.cfg":
      source    => "puppet:///modules/nagios/private/resource.cfg",
      ensure    => present,
      owner =>     "nagios",
      group =>     "nagios",
      require   => File["/etc/nagios/nagios.cfg"],
    }

    file { "/etc/nagios/passwd":
      source    => "puppet:///modules/nagios/httpd/nagios.users",
      require   => File["/etc/nagios/"],
      owner => root,
      group => root,
      ensure    => present
    }

    file { ["/usr/local/nagios/","/usr/local/nagios/var/","/usr/local/nagios/var/spool","/usr/local/nagios/var/spool/checkresults"]:
       ensure => directory,
       owner =>     "nagios",
       group =>     "nagios",
       require =>  File["/etc/nagios/nagios.cfg"]
    }

    exec { "setup_object_files_in_config" :
      command => "sed -i 's/^cfg_file\s*=.*$//g' /etc/nagios/nagios.cfg ; find /etc/nagios/objects -name \\*cfg | sed 's/\\(.*\\)/cfg_file=\\1/g' >> /etc/nagios/nagios.cfg",
      require => File["/etc/nagios/nagios.cfg"]
    }

    service { "nagios":
        ensure  => running,
        require => [File["/usr/lib64/nagios/plugins/"],Exec["setup_object_files_in_config"],File["/etc/nagios/nrpe.cfg"],File["/etc/httpd/conf.d/nagios.conf"]]
    }

    exec { "remove_nagios_package" :
             command => "rm -rf /tmp/nagios_package",
             require   => Service["nagios"]
        }
}