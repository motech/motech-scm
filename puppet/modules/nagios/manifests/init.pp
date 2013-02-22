    class nagios ($nagios_config_url, $nagios_objects_path, $nagios_plugins_path, $host_file_path) {

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
        require => Exec["fetch_nagios_config_package"],
        cwd     => "/tmp/nagios_package",
        alias   => "unjar_nagios_package"
    }

    file { "/etc/nagios/objects/":
      source    => "/tmp/nagios_package/${nagios_objects_path}",
      recurse   => true,
      purge     => true,
      require   => Exec["unjar_nagios_package"]
    }

    file { "/usr/lib64/nagios/plugins/":
      source    => "/tmp/nagios_package/${nagios_plugins_path}",
      recurse   => true,
      owner => "nagios",
      group => "nagios",
      mode      =>  554,
      require   => File["/etc/nagios/objects/"]
    }

    file { "/etc/nagios/objects/hosts.cfg":
      source    => "/tmp/nagios_package/${host_file_path}",
      require   => Exec["unjar_nagios_package"]
    }

    exec { "setup_object_files_in_config" :
        command => "sed -i 's/^cfg_file\s*=.*$//g' /etc/nagios/nagios.cfg ; find /etc/nagios/objects -name \\*cfg | sed 's/\\(.*\\)/cfg_file=\\1/g' >> /etc/nagios/nagios.cfg",
        require => File["/etc/nagios/objects/"]
    }

    service { "nagios":
        ensure  => running,
        require => [ Exec["setup_object_files_in_config"], File["/usr/lib64/nagios/plugins/"] ]
    }

    exec { "remove_nagios_package" :
             require   => Service["nagios"],
             command => "rm -rf /tmp/nagios_package"
        }
}