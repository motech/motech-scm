class keepalived (machine_type, check_services_script_path, interface, priority, virtual_ipaddress){
	package { "keepalived":
		ensure => "present",
	}

	service { "keepalived":
        ensure      => running,
        enable      => true,
        hasrestart  => true,
        hasstatus   => true,
        require     => File["/etc/keepalived/keepalived.conf"],
    }

    file { "/etc/keepalived/keepalived.conf":
        content     => template("keepalived/keepalived.conf.erb"),
        require     => Package["keepalived"]
    }
}