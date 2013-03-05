##-----------------------------MOTECH BOOTSTRAP---------------------------------------
##  Save and exit to continue with setup.
##------------------------------------------------------------------------------------

##--------------------------------SETTINGS--------------------------------------------
## Operating System
$os = "centos5" ## [centos5 | centos6]
$word = "32b" ## [32b,64b]
$arch = "x64" ## [x64|i586]

## User
## To generate password hash use 'echo "password" | openssl passwd -1 -stdin'
$motechUser = "motech"
$motechPassword = '$1$IW4OvlrH$Kui/55oif8W3VZIrnX6jL1'

## MYSQL
$mysqlPassword = "password"

## Monitor
$monitor_adminPhoneNumbers = "9880xxxxxx 9880xxxxxx"
$monitor_kookooKey = "xxx"
$monitor_environment = "production"
$monitor_app_url = "http://localhost:8080/tama/login"

## CouchDb
## Present installs the newest version when nothing is installed
$couchdbPackageName = "couchdb" ## ["couchdb" | "apache-couchdb"]
$couchVersion = "1.2.0-7.el6" ## ["1.0.1-4.el5" | "1.0.3-2.el6" | "1.2.0-7.el6" ]
$couchDatabaseDir = "/var/lib/couchdb"
$couchInstallationMode = "standalone" ## [standalone | withReplication]
$couchReplicationSourceMachine = "127.0.0.1"
$couchBindAddress = "127.0.0.1"
$couchDbs = "tama-web ananya"
$couchDbBackupLink = "/opt/backups/couchdb"

$couchdbClusteringEnabled = true
$couchdbClusterPort = 8181
$couchdbPrimaryIp = "192.168.42.51"
$couchdbSecondaryIp = "192.168.42.52"

## CouchDb-Lucene
$couchDbURL="http://localhost:5984/"

## Postgres
$postgresUser="postgres"
$postgresPassword= '$1$IW4OvlrH$Kui/55oif8W3VZIrnX6jL1'
$postgresMachine = "master" ## [master | slave]
$postgresMaster = "127.0.0.1"
$postgresSlave = "127.0.0.1"
$postgresBackupLink = "/opt/backups/postgres"
# $postgresDataLocation = "/usr/local/pgsql/data"
$changeDefaultEncodingToUTF8 = false

## Data Backup
$dataBackupDir = "/opt/backups"
$machineType = "master" ## [master | slave]

## ActiveMQ
$activemqMachine = "master" ## [master | slave]
$activemqMasterHost = "127.0.0.1"
$activemqMasterPort = 61616
$activemqDataDir = "/home/${motechUser}/apache-activemq-5.5.1" ## Root directory of activemq data directory
$activemqMemoryLimit = "1mb"

## SSH
$SSHPort = "12200"
$SSHPublicKeyFilePath = "" ## Provide valid file path containing public key to be added to .ssh/authorized_keys.
$DeactivatePasswordAuthentication = false ## true if password login to be enabled

## Iptables Configuration
$admin_access_ips = "127.0.0.1" ## Space seperated list of ips. example "11.1.1.1 2.2.2.2"
$ssh_allowed_ips = "0/0"  ## Space seperated list of ips. example "11.1.1.1 2.2.2.2"
$tcp_ports_open = "80 443" ## List of ports that can be accessed from outside world.
$ssh_port = "22" ## Port on which ssh daemon works.

## Hostname Configuration
$host_name="localhost"
$env="<environment>"

## Nagios
$nagios_config_url = 'http://192.168.42.26:8080/job/Ananya-Delivery-Kilkari/lastStableBuild/org.motechproject.ananya$ananya-deploy/artifact/org.motechproject.ananya/ananya-deploy/0.2.1-SNAPSHOT/ananya-deploy-0.2.1-SNAPSHOT.jar'
$nagios_objects_path = "nagios/objects/"
$nagios_plugins_path = "nagios/plugins/"
$host_file_path = "properties/${env}/hosts.cfg" ## env is the environment for nagios configuration

## Keepalived
$machine_type = "MASTER" ## Can be one of MASTER/SLAVE
$check_services_script_path = "/root/checkservices.sh" ## Path of the script that will be executed at scheduled intervals. Should return 0 for success and 1 for failure.
$interface = "eth0"
$priority = "101" ## Higher the priority the virtual ip address will be attached to that node
$virtual_ipaddress = "192.168.42.38/24" ## Virtual ip address that is attached to the winning node

## Tomcat 7.0.22 configuration

$tomcatManagerPassword = "p@ssw0rd"
$tomcatManagerRoles = "manager-script"

## Optional
$tomcatManagerUserName = "tomcat"
$tomcatHttpPort="8080"
$tomcatRedirectPort="8443"
$tomcatShutdownPort="8005"
$tomcatAjpPort="8009"
$tomcatInstance = "primary" ## [primary / secondary] This suffix will be discriminator for tomcat installations

######################## HTTPD CONFIG START#############################################
## HTTPD
$sslEnabled = true
$sslExcludeList = ["10.155.8.115","127.0.0.1","192.168.42.45"]
$dropPacketsIfIPNotInSslExcludeList = false # true if the packets have to dropped when accessed over http

## The following redirects can contain either a string or an array;
## If it is a string, the same is used for both ProxyPass and ProxyPassReverse rules;
## In case of array, 1st element of the array specifies ProxyPass rule and 2nd element specifies ProxyPassReverse rule.
$httpRedirects = ["/ananya/ http://192.168.42.38:8080/ananya/"]
$httpsRedirects = ["/nagios http://192.168.42.45/nagios",
				   "/ananya-batch http://192.168.42.45:8081/ananya-batch",
				   ["/jasperserver ajp://192.168.42.45:8010/jasperserver",
					"/jasperserver http://192.168.42.45:8081/jasperserver"
				   ]
				  ]

## HTTPS
$SSLCertificateFile = "/etc/pki/tls/certs/localhost.crt"
$SSLCertificateKeyFile = "/etc/pki/tls/private/localhost.key"
$sslCertificateChainFile = "" ## Leave blank if no chain certificate is required.
$sslCACertificateFile = "" ## Leave blank if no CA certificate is required.
$serverName = "" ##ServerName entry in httpd and ssl conf

## Authentication
$authenticationRequired = false     ## Specify if authentication is necessary.
$authenticationKey = "APIKey"             ## The key which is to be authenticated.
$authenticationValues = ["1234","5678"]           ## The values which must be compared for authentication.
## Use property httpsRedirects to setup proxypass redirects
$authenticationExcludeHosts = []
$authenticationExcludeUrlPatterns = []

######################## HTTPD CONFIG END################################################

######################## JASPER CONFIG START##############################################
$jasperTomcatHome = "/home/motech/apache-tomcat-7.0.22-secondary"
$jasperHome = "/home/motech/jasperserver-5.0.0-bin"
$jasperDbType = "postgresql" #Or "mysql" for mysql database.
$jasperDbHost = "localhost"
$jasperDbUsername = "postgres"
$jasperDbPassword = "password"
$jasperDbName = "jasperserver"
$jasperResetDb = "y" ## Provide "y" or "n"
$jasperPatches = "patch_add_export_restriction patch_turn_off_snapshot_feature"  #space separated list
######################## JASPER CONFIG END################################################


##--------------------------------RESOURCES--------------------------------------------
## Comment out resources not required to be installed. And setup class dependencies using "->"

# class { users : userName => "${motechUser}", password => "${motechPassword}" }
# class { keepalived : machine_type => "${machine_type}", check_services_script_path => "${check_services_script_path}", interface => "${interface}", priority => "${priority}", virtual_ipaddress => "${virtual_ipaddress}" }
# class { couchdb : couchdbPackageName => "${couchdbPackageName}", couchReplicationSourceMachine => "${couchReplicationSourceMachine}", couchDbs => "${couchDbs}", couchInstallationMode => "${couchInstallationMode}", couchVersion => "${couchVersion}", couchDatabaseDir => "${couchDatabaseDir}", couchBindAddress => "${couchBindAddress}" }
# class { postgres : postgresUser => "${postgresUser}", postgresPassword => "${postgresPassword}", postgresMachine => "${postgresMachine}", postgresMaster => "${postgresMaster}", postgresSlave => "${postgresSlave}", os => "${os}", wordsize => "${word}", changeDefaultEncodingToUTF8 => "${changeDefaultEncodingToUTF8}" }
# class { databackup : couchDbBackupLink => "${couchDbBackupLink}", postgresBackupLink => "${postgresBackupLink}", dataBackupDir => "${dataBackupDir}", machineType => "${machineType}" }
# class { activemq : version => "5.5.1", activemqMachine => "${activemqMachine}", activemqMasterHost => "${activemqMasterHost}", activemqMasterPort => "${activemqMasterPort}", activemqDataDir => "${activemqDataDir}", memoryLimit => "${activemqMemoryLimit}" }
# class { iptables : admin_access_ips => "${admin_access_ips}", ssh_allowed_ips => "${ssh_allowed_ips}", tcp_ports_open => "${tcp_ports_open}", ssh_port => "${ssh_port}" }
# class { hostname : host_name => "${host_name}" }
# class { httpd : sslEnabled => $sslEnabled, sslCertificateFile => "${SSLCertificateFile}", sslCertificateKeyFile => "${SSLCertificateKeyFile}", sslCertificateChainFile => $sslCertificateChainFile, sslCACertificateFile => $sslCACertificateFile, serverName => $serverName}
# class { tomcat : version => "7.0.22", userName => "${motechUser}", tomcatManagerUserName => "${tomcatManagerUserName}", tomcatManagerPassword => "${tomcatManagerPassword}", tomcatInstance => "${tomcatInstance}", tomcatHttpPort => "${tomcatHttpPort}", tomcatRedirectPort => "${tomcatRedirectPort}", tomcatShutdownPort => "${tomcatShutdownPort}", tomcatAjpPort => "${tomcatAjpPort}" }
# class { jasperserver : jasperPatches => "${jasperPatches}" }
# class { couchdblucene : version => "0.9.0-SNAPSHOT" }
# class { repmgr : postgresVersion => "9.1", repmgrVersion => "1.2.0" }
# class { scripts : urlOfScriptsJar => "your project scripts jar" }
# class { nagios : nagios_config_url => "${nagios_config_url}", nagios_objects_path => "${nagios_objects_path}", nagios_plugins_path => "${nagios_plugins_path}", host_file_path => "${host_file_path}" }
# class { faketime : javaHome => "path/to/java/home" , sunBootLibraryPath => "sun.boot.library.path"}

# include git
# include httpd
# include ant
# include mysql
# include mysqlserver
# include asterisk
# include activemq
# include tomcat
# include duplicity
# include motechquartz
# include monitor
# include verboice
# include doxygen
# include ruby
# include ssh
# include nagios

## nscd is name service caching daemon. It provides caching for many service requests, mainly dns lookup.
# include nscd
