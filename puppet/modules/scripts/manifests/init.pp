class scripts($urlOfScriptsJar) {

    exec { "getScriptsJar" :
        command => "/usr/bin/wget -O /tmp/scripts.jar $urlOfScriptsJar",
        onlyif => "test ! -f /tmp/scripts.jar",
    }

    exec { "resetScriptsFolder" :
            command => "rm -rf /tmp/scripts",
            onlyif => "test  -d /tmp/scripts",
    }

    exec { "createScriptsFolder" :
        command => "mkdir /tmp/scripts",
        require => Exec["resetScriptsFolder"]
        onlyif => "test ! -d /tmp/scripts",
    }

    exec { "unJarScripts" :
        cwd => "/tmp/scripts",
        command => "unzip /tmp/scripts.jar",
        require => [Exec["createScriptsFolder"], Exec["getScriptsJar"]],
        onlyif => "test ! -f /tmp/scripts/install.sh",
    }

    exec { "install-scripts" :
        cwd => "/tmp/scripts",
        command => "sh install.sh",
        require => Exec["unJarScripts"]
    }
}
