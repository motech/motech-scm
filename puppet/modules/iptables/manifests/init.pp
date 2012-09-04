class iptables($admin_access_ips,$ssh_allowed_ips,$tcp_ports_open,$ssh_port) {
	package { "iptables" :
		ensure  =>  "present"
	}
	exec {
          "backup_iptables_conf":
              cwd     => "/etc/sysconfig/",
              command => "cp iptables iptables.backup",
              require => Package["iptables"],
              onlyif => "[ -f /etc/sysconfig/iptables ]"

     }
	file {"/home/${motechUser}/configure_iptables.sh" :
        content => template("iptables/configure_iptables.sh"),
        owner => "${motechUser}",
        group => "${motechUser}",
        mode   =>  764,
        require => Exec["backup_iptables_conf"],
    }
	exec {"configure-iptables" :
        require => File["/home/${motechUser}/configure_iptables.sh"],
	command => "sh /home/${motechUser}/configure_iptables.sh ${admin_access_ips} ${ssh_allowed_ips} ${tcp_ports_open} ${ssh_port}"}
}
