class faketime($javaHome, $sunBootLibraryPath) {

    file { "/tmp/faketime.tar.gz" :
        source => "puppet:///modules/faketime/faketime.tar.gz",
        ensure => "present",
    }

    exec { "recreateWorkingDirectory":
        command => "rm -rf /tmp/jvmfaketime; mkdir /tmp/jvmfaketime;",
        require => File["/tmp/faketime.tar.gz"],
    }

    exec { "unTarFakeTime" :
        cwd => "/tmp/jvmfaketime",
        command => "tar -xvf /tmp/faketime.tar.gz",
        require => Exec["recreateWorkingDirectory"],
    }


    exec { "setJavaOpts":
        command => "echo \"\\\nexport JAVA_OPTS=\\\"-Xbootclasspath/p:$javaHome/jre/lib/jvmfaketime.jar\\\"\" >> /etc/environment",
        require => Exec["unTarFakeTime"],
    }

    exec { "setMavenOpts":
        command => "echo \"\\\nexport MAVEN_OPTS=\\\"-Xbootclasspath/p:$javaHome/jre/lib/jvmfaketime.jar\\\"\" >> /etc/environment",
        require => Exec["setJavaOpts"],
    }

    exec { "install-faketime" :
        cwd => "/tmp/jvmfaketime/faketime",
        command => "cp -f jvmfaketime.jar $javaHome/jre/lib; cp -f libjvmfaketime.so $sunBootLibraryPath",
        require => Exec["setMavenOpts"],
    }
}
