class hostname ($host_name){
      file {"/home/${motechUser}/config-hostname.sh" :
            content => template("hostname/config-hostname.sh"),
            owner => "${motechUser}",
            group => "${motechUser}",
            mode   =>  764,
        }

        exec { "configure-hostname":
            require => File["/home/${motechUser}/config-hostname.sh"],
            command => "/bin/sh /home/${motechUser}/config-hostname.sh ${host_name}",
            user => "root",
        }
}
