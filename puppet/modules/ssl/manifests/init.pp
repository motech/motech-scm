class ssl ( $userName, $sslCertificateFile, $sslCertificateKeyFile ) {
	package { "mod_ssl" :
		ensure  =>  "present",
	}

	file { "/home/${userName}/configure-ssl.sh" :
        content => template("ssl/configure-ssl.sh"),
        owner => "${userName}",
        group => "${userName}",
        mode   =>  764,
        require => Package["mod_ssl"],
    }

	exec { "config-ssl" :
        command => "/bin/sh /home/${userName}/configure-ssl.sh ${sslCertificateFile} ${sslCertificateKeyFile} ",
        require => File["/home/${userName}/configure-ssl.sh"],
	}
}
