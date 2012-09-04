class ssh {
         file {"/home/${motechUser}/configure_sshd.sh" :
         content => template("ssh/configure_sshd.sh"),
         owner => "${motechUser}",
         group => "${motechUser}",
         mode   =>  764
         }

         file {"/home/${motechUser}/configure_public_keys.sh" :
         content => template("ssh/configure_public_keys.sh"),
         owner => "${motechUser}",
         group => "${motechUser}",
         mode   =>  764
         }

         exec {"config-ssh" :
         require => File["/home/${motechUser}/configure_sshd.sh"],
         command => "sh /home/${motechUser}/configure_sshd.sh ${SSHPort} ${motechUser} ${DeactivatePasswordAuthentication} "
         }

         exec {"config-public-keys" :
         require => File["/home/${motechUser}/configure_public_keys.sh"],
         command => "sh /home/${motechUser}/configure_public_keys.sh ${SSHPublicKeyFilePath} ${motechUser} "
         }

         exec {"delete-config-files" :
         require => Exec["config-ssh", "config-public-keys"],
         command => "rm -rf /home/${motechUser}/configure_sshd.sh /home/${motechUser}/configure_public_keys.sh"
         }
 }