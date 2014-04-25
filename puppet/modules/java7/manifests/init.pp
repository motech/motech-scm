class java7($motechUser,$arch="x64"){


    package { "java-1.7.0-openjdk.x86_64":
        ensure => absent,
    }

    package { "java-1.6.0-openjdk.x86_64":
        ensure => absent,
    }


    exec { "downloadOracleJava7" :
      command     => "/usr/bin/wget -O /tmp/java/jdk-7u51-linux-${arch}.rpm --no-check-certificate --no-cookies  --header 'Cookie: oraclelicense=accept-securebackup-cookie' http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-${arch}.rpm",
      user        => "${motechUser}",
      timeout     => 0,
      provider    => "shell",
      onlyif      => "test ! -f /tmp/java/jdk-7u51-linux-${arch}.rpm",
      require     => [File["/tmp/java/"], Package["java-1.7.0-openjdk.x86_64"], Package["java-1.6.0-openjdk.x86_64"]]
    }

    exec {"installJava7" :
      command     => "rpm -Uvh /tmp/java/jdk-7u51-linux-${arch}.rpm",
      path => ["/usr/bin/","/usr/sbin/","/bin"],
      timeout     => 0,
      user        => root,
      onlyif      => "test `sudo rpm -qa|grep jdk-1.7.0_51-fcs.x86_64|wc -l` -eq 0",
      require     => Exec["downloadOracleJava7"],
    }

    file { "/tmp/java/":
      ensure => "directory",
      owner => "${motechUser}",
      group => "${motechUser}",
      mode => "0755",
    }


}