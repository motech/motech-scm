class scripts($urlOfScriptsJar) {

    exec { "getScriptsJar" :
        command => "/usr/bin/wget -O /tmp/scripts.jar $urlOfScriptsJar",
        onlyif => "test ! -f /tmp/scripts.jar",
    }

    exec { "unJarScripts" :
        cwd => "/tmp",
        command => "tar -xvf /tmp/scripts.jar",
        require => Exec["getScriptsJar"],
        onlyif => "test ! -d /tmp/scripts",
    }

    exec { "install-scripts" :
        cwd => "/tmp/scripts",
        command => "sh install.sh",
        require => Exec["unJarScripts"]
    }
}
