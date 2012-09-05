
class users ( $userName, $password ) {
  user { "${userName}":
      ensure     => present,
      shell      => "/bin/bash",
      home       => "/home/${userName}",
      password   => $password,
  }
  
  exec { "$userName homedir":
    command => "/bin/cp -R /etc/skel /home/$userName; /bin/chown -R $userName:$userName /home/$userName",
    creates => "/home/$userName",
    require => User[$userName],
  }

  file { "add-user-to-sudoers.sh" :
    path => "/home/${userName}/add-user-to-sudoers.sh",
    content => template("users/add-user-to-sudoers.sh"),
    owner => "${userName}",
    group => "${userName}",
    mode   =>  764,
    require => Exec["$userName homedir"],
  }

  exec { "add-user-to-sudoers":
      command => "/bin/sh /home/${userName}/add-user-to-sudoers.sh ${userName}",
      require => File["add-user-to-sudoers.sh"],
  }
}