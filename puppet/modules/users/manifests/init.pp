class users ( $userName, $password ) {

    user { "${userName}":
        ensure      => present,
        shell       => "/bin/bash",
        home        => "/home/${userName}",
        password    => $password,
    }

    exec { "$userName homedir":
        provider    => "shell",
        command     => "/bin/cp -R /etc/skel /home/$userName; /bin/chown -R $userName:$userName /home/$userName",
        creates     => "/home/$userName",
        onlyif      => "test ! -f /home/${userName}/.bashrc",
        require     => User[$userName],
    }

    file { "add-user-to-sudoers.sh" :
        ensure      => present,
        path        => "/home/${userName}/add-user-to-sudoers.sh",
        content     => template("users/add-user-to-sudoers.sh"),
        owner       => "${userName}",
        group       => "${userName}",
        mode        => 764,
        require     => Exec["$userName homedir"],
    }

    exec { "add-user-to-sudoers":
        provider    => "shell",
        command     => "/bin/sh /home/${userName}/add-user-to-sudoers.sh ${userName}",
        onlyif      => "test `grep -i ${userName} /etc/sudoers  | wc -l` -eq 0",
        require     => File["add-user-to-sudoers.sh"],
    }
}