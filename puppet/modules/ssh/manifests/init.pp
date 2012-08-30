class ssh {
	file {"/home/${motechUser}/configure_sshd.sh" :
        content => template("ssh/configure_sshd.sh"),
        owner => "${motechUser}",
        group => "${motechUser}",
        mode   =>  764,
    }
	exec {"config-ssh" :
        require => File["/home/${motechUser}/configure_sshd.sh"],
	command => "sh /home/${motechUser}/configure_sshd.sh ${SSHPort} ${SSHPublicKeyFilePath} ${motechUser} "}

	exec {
	    command => rm /home/${motechUser}/configure_sshd.sh
	}
}
