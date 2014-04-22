##-----------------------------MOTECH BOOTSTRAP---------------------------------------
##  Save and exit to continue with setup.
##------------------------------------------------------------------------------------

##--------------------------------SETTINGS--------------------------------------------
## Operating System
$os = "centos6" ## [centos5 | centos6]
$word = "64b" ## [32b,64b]
$arch = "x64" ## [x64|i586]

## User
$motechUser = "motech"

## **************************************************************************************
## To generate password hash use [[echo "password" | openssl passwd -1 -stdin] OR [echo "password" | openssl passwd -1 -stdin | sed 's/\$/\\\$/g']]
## **************************************************************************************
## *****  WARNING   ****  WARNING   ****  WARNING   ****  WARNING   ****  WARNING   *****
## **************************************************************************************
## String generated should have '$'s escaped. Or should be written within single quotes.
## For eg:
## $motechPassword = "\$1\$IW4OvlrH\$Kui/55oif8W3VZIrnX6jL1"
## $motechPassword = '$1$IW4OvlrH$Kui/55oif8W3VZIrnX6jL1'
## **************************************************************************************

$motechPassword = "\$1\$IW4OvlrH\$Kui/55oif8W3VZIrnX6jL1"

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

$couchdbClusteringEnabled = false
$couchdbClusterPort = 8181
$couchdbPrimaryIp = "192.168.42.51"
$couchdbSecondaryIp = "192.168.42.52"

## CouchDb-Lucene
$couchDbURL = "http://localhost:5984/"
$couchdbLuceneVersion = "0.9.0-SNAPSHOT"

## Postgres
$postgresUser = "postgres"
$postgresTimeZone = "UTC"

## **************************************************************************************
## To generate password hash use [[echo "password" | openssl passwd -1 -stdin] OR [echo "password" | openssl passwd -1 -stdin | sed 's/\$/\\\$/g']]
## **************************************************************************************
## *****  WARNING   ****  WARNING   ****  WARNING   ****  WARNING   ****  WARNING   *****
## **************************************************************************************
## String generated should have '$'s escaped. Or should be written within single quotes.
## For eg:
## $motechPassword = "\$1\$IW4OvlrH\$Kui/55oif8W3VZIrnX6jL1"
## $motechPassword = '$1$IW4OvlrH$Kui/55oif8W3VZIrnX6jL1'
## **************************************************************************************

$postgresPassword = '$1$IW4OvlrH$Kui/55oif8W3VZIrnX6jL1'
$postgresMachine = "master" ## [master | slave]
$postgresMaster = "127.0.0.1"
$postgresSlave = "127.0.0.1"
$changeDefaultEncodingToUTF8 = false

# postgres version used for repmgr as well
$postgresVersion = "9.3"
$pgPackVersion="93" ##used to ensure that postgres packs like postgresql91-contrib are present [91|93, default is 91]
# Rep Manager version
$repmgrVersion = "1.2.0"

## Data Backup
$couchDbBackupLink = "/opt/backups/couchdb"
$postgresBackupLink = "/opt/backups/postgres"
$dataBackupDir = "/opt/backups"
$machineType = "master" ## [master | slave]

## ActiveMQ
$activemqMachine = "master" ## [master | slave]
$activemqMasterHost = "127.0.0.1"
$activemqMasterPort = 61616
$activemqDataDir = "/home/${motechUser}/apache-activemq-5.5.1" ## Root directory of activemq data directory
$activemqMemoryLimit = "1mb"
$activemqVersion = "5.5.1"

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
$host_name = "localhost"

## Nagios
$env = "" ## env is the environment for nagios configuration
$nagios_config_url = 'http://old-ci.motechproject.org/job/motech-whp-deploy/lastStableBuild/org.motechproject.whp%24whp-mTraining-deploy/artifact/org.motechproject.whp/whp-mTraining-deploy/0.7-SNAPSHOT/whp-mTraining-deploy-0.7-SNAPSHOT.jar'
$nagios_objects_path = "nagios/whp-mtraining/objects/"
$nagios_plugins_path = "nagios/plugins/"
$host_file_path = "nagios/whp-mtraining/objects/hosts.cfg"
$nrpe_config_path = "nagios/nrpe/etc/nrpe.cfg"

## Keepalived
$machine_type = "MASTER" ## Can be one of MASTER/SLAVE
$check_services_script_path = "/root/checkservices.sh" ## Path of the script that will be executed at scheduled intervals. Should return 0 for success and 1 for failure.
$interface = "eth0"
$priority = "101" ## Higher the priority the virtual ip address will be attached to that node
$virtual_ipaddress = "192.168.42.38/24" ## Virtual ip address that is attached to the winning node

## Tomcat 7.0.22 configuration
$tomcatInstance = "" ## [[blank] / primary / secondary] This suffix will be discriminator for tomcat installations. Can be left blank.
$tomcatManagerUserName = "" ## If left blank no tomcat manager user will be created.
$tomcatManagerPassword = ""
$tomcatManagerRoles = ["manager-gui", "manager-script", "manager-status"]
$tomcatHttpPort = "8080"
$tomcatRedirectPort = "8443"
$tomcatShutdownPort = "8005"
$tomcatAjpPort = "8009"
$tomcatVersion = "7.0.22"

######################## HTTPD CONFIG START#############################################
## HTTPD
## The following redirects can contain either a string or an array;
## If it is a string, the same is used for both ProxyPass and ProxyPassReverse rules;
## In case of array, 1st element of the array specifies ProxyPass rule and 2nd element specifies ProxyPassReverse rule.
$httpRedirects = ["/whp-mtraining/ http://localhost:8080/motech-platform-server/"]

## HTTPS
$sslEnabled = false
$sslExcludeList = ["10.155.8.115","127.0.0.1","192.168.42.45"]
$dropPacketsIfIPNotInSslExcludeList = false # true if the packets have to dropped when accessed over http

## The following redirects can contain either a string or an array;
## If it is a string, the same is used for both ProxyPass and ProxyPassReverse rules;
## In case of array, 1st element of the array specifies ProxyPass rule and 2nd element specifies ProxyPassReverse rule.
#$httpsRedirects = ["/nagios http://192.168.42.45/nagios",
#				   "/ananya-batch http://192.168.42.45:8081/ananya-batch",
#				   ["/jasperserver ajp://192.168.42.45:8010/jasperserver",
#					"/jasperserver http://192.168.42.45:8081/jasperserver"
#				   ]
#				  ]

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

## logrotate config
$logRotateConfigFileName = "test-whp-mtraining"
$logFilePath = "/home/${motechUser}/apache-tomcat-7.0.22/logs/catalina.out"
$selinuxFileContextType = "var_log_t" ## If there are selinux restrictions for log file, provide appropriate fcontext type, else leave it empty

## GlusterFS Config - Find README in glusterfs module for details
$peer = "192.168.42.2"
$volumeName = "activemq-cluster-volume"
$volumeCreationOptions = "replica 2 transport tcp 192.168.42.1:/home/motech/apache-activemq-5.5.1/data 192.168.42.2:/home/motech/apache-activemq-5.5.1/data"
$mountPoint = "/mnt/glusterfs"
$volumeToMount = "192.168.42.1:/activemq-cluster-volume"

## Maven
$mavenVersion = "3.0.5"

## Ant
$antVersion = "1.8.2"

##--------------------------------RESOURCES--------------------------------------------
## Comment out resources not required to be installed. And setup class dependencies using "->"

# class { users : userName => "${motechUser}", password => "${motechPassword}" }
# class { keepalived : machine_type => "${machine_type}", check_services_script_path => "${check_services_script_path}", interface => "${interface}", priority => "${priority}", virtual_ipaddress => "${virtual_ipaddress}" }
# class { couchdb : couchdbPackageName => "${couchdbPackageName}", couchReplicationSourceMachine => "${couchReplicationSourceMachine}", couchDbs => "${couchDbs}", couchInstallationMode => "${couchInstallationMode}", couchVersion => "${couchVersion}", couchDatabaseDir => "${couchDatabaseDir}", couchBindAddress => "${couchBindAddress}" }
#class { postgres : postgresUser => "${postgresUser}", postgresPassword => "${postgresPassword}", postgresMachine => "${postgresMachine}", postgresMaster => "${postgresMaster}", postgresSlave => "${postgresSlave}", os => "${os}", wordsize => "${word}", changeDefaultEncodingToUTF8 => "${changeDefaultEncodingToUTF8}" ,postgresTimeZone => "${postgresTimeZone}",pgPackVersion => "${pgPackVersion}",postgresVersion => "${postgresVersion}" }
# class { databackup : couchDbBackupLink => "${couchDbBackupLink}", postgresBackupLink => "${postgresBackupLink}", dataBackupDir => "${dataBackupDir}", machineType => "${machineType}" }
# class { activemq : version => "${activemqVersion}", activemqMachine => "${activemqMachine}", activemqMasterHost => "${activemqMasterHost}", activemqMasterPort => "${activemqMasterPort}", activemqDataDir => "${activemqDataDir}", memoryLimit => "${activemqMemoryLimit}" }
# class { iptables : admin_access_ips => "${admin_access_ips}", ssh_allowed_ips => "${ssh_allowed_ips}", tcp_ports_open => "${tcp_ports_open}", ssh_port => "${ssh_port}" }
# class { hostname : host_name => "${host_name}" }
#class { httpd : sslEnabled => $sslEnabled, sslCertificateFile => "${SSLCertificateFile}", sslCertificateKeyFile => "${SSLCertificateKeyFile}", sslCertificateChainFile => $sslCertificateChainFile, sslCACertificateFile => $sslCACertificateFile, serverName => $serverName, httpRedirects => $httpRedirects}
# class { tomcat : version => "${tomcatVersion}", userName => "${motechUser}", tomcatManagerUserName => "${tomcatManagerUserName}", tomcatManagerPassword => "${tomcatManagerPassword}", tomcatInstance => "${tomcatInstance}", tomcatHttpPort => "${tomcatHttpPort}", tomcatRedirectPort => "${tomcatRedirectPort}", tomcatShutdownPort => "${tomcatShutdownPort}", tomcatAjpPort => "${tomcatAjpPort}" }
# class { jasperserver : jasperPatches => "${jasperPatches}" }
# class { couchdblucene : version => "${couchdbLuceneVersion}" }
# class { repmgr : postgresVersion => "${postgresVersion}", repmgrVersion => "${repmgrVersion}" }
# class { scripts : urlOfScriptsJar => "your project scripts jar" }
#class { nagios : nagios_config_url => "${nagios_config_url}", nagios_objects_path => "${nagios_objects_path}", nagios_plugins_path => "${nagios_plugins_path}", host_file_path => "${host_file_path}", nrpe_config_path => "${nrpe_config_path}"}
# class { faketime : javaHome => "path/to/java/home" , sunBootLibraryPath => "sun.boot.library.path"}
# class { phantomjs }
# class { maven: version => "${mavenVersion}" }
# class { ant: version => "${antVersion}" }

## Sample logrotate class declaration. For all possible arguments, look at rule.pp of logrotate module.
## logrotate timing for a day is based on the cron job defined in /etc/crontab or /etc/anacrontab.
#include logrotate::base
#logrotate::rule { "${logRotateConfigFileName}" : path => "${logFilePath}", rotate => 30, rotate_every => "day", copytruncate => true, dateext => true, compress => true, delaycompress => true, ifempty => false, missingok => true }

## GlusterFS setup - Find README in glusterfs module for details
#class { "glusterfs::server" : peers => "${peer}" }
#glusterfs::volume { "${volumeName}" : create_options => "${volumeCreationOptions}" }
#glusterfs::mount { "${mountPoint}" : device => "${volumeToMount}" }

# include git
# include mysql
# include mysqlserver
# include asterisk
# include duplicity
# include motechquartz
# include monitor
# include verboice
# include doxygen
# include ruby
# include ssh
# include phantomjs

## nscd is name service caching daemon. It provides caching for many service requests, mainly dns lookup.
# include nscd
include backup::postgres
include backup::couchdb