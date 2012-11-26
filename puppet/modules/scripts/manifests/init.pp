class scripts($urlOfScriptsJar) {

    exec { "getScriptsJar" :
        command => "/usr/bin/wget -O /tmp/scripts.jar $urlOfScriptsJar",
        onlyif => "test ! -f /tmp/scripts.jar",
    }

    exec { "createScriptsFolder" :
        command => "mkdir /tmp/scripts",
        onlyif => "test ! -d /tmp/scripts",
    }

    exec { "unJarScripts" :
        cwd => "/tmp/scripts",
        command => "jar -xvf /tmp/scripts.jar",
        require => [Exec["createScriptsFolder"], Exec["getScriptsJar"]],
        onlyif => "test -d /tmp/scripts",
    }

    exec { "install-scripts" :
        cwd => "/tmp/scripts",
        command => "sh install.sh",
        require => Exec["unJarScripts"]
    }
}
