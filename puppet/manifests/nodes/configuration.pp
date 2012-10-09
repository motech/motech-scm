 #-----------------------------MOTECH BOOTSTRAP---------------------------------------
 #  Save and exit to continue with setup.
 #------------------------------------------------------------------------------------

 #--------------------------------SETTINGS--------------------------------------------
 # operatingsystem
 $os = "centos5" #[centos5 | centos6]
 $word = "32b" #[32b,64b]
 $arch = "x64" # [x64|i586]

 # user
 # to generate password hash use 'echo "password" | openssl passwd -1 -stdin'
 $motechUser = "motech"
 $motechPassword = '$1$IW4OvlrH$Kui/55oif8W3VZIrnX6jL1'

 # mysql
 $mysqlPassword = "password"

 # monitor
 $monitor_adminPhoneNumbers = "9880xxxxxx 9880xxxxxx"
 $monitor_kookooKey = "xxx"
 $monitor_environment = "production"
 $monitor_app_url = "http://localhost:8080/tama/login"

 # couchdb
 # present installs the newest version when nothing is installed
 $couchdbPackageName = "couchdb" #["couchdb" | "apache-couchdb"]
 $couchVersion = "present" #["1.0.1-4.el5" | "1.0.3-2.el6" | "1.2.0-7.el6" | "present" ]
 $couchDatabaseDir = "/var/lib/couchdb"
 $couchInstallationMode = "standalone" #[standalone | withReplication]
 $couchReplicationSourceMachine = "127.0.0.1"
 $couchDbs = "tama-web ananya"
 $couchDbBackupLink = "/opt/backups/couchdb"

#couchdb-lucene
 $couchDbURL="http://localhost:5984/"

 # postgres
 $postgresUser="postgres"
 $postgresPassword= '$1$IW4OvlrH$Kui/55oif8W3VZIrnX6jL1'
 
 $postgresMachine = "master" #[master | slave]
 $postgresMaster = "127.0.0.1"
 $postgresSlave = "127.0.0.1"
 $postgresBackupLink = "/opt/backups/postgres"
 #$postgresDataLocation = "/usr/local/pgsql/data"

 # data backup
 $dataBackupDir = "/opt/backups"
 $machineType = "master" #[master | slave]

 # activemq
 $activemqMachine = "master" #[master | slave]
 $activemqMasterHost = "127.0.0.1"
 $activemqMasterPort = 61616
 $activemqDataDir = "/home/${motechUser}/apache-activemq-5.5.1" #Root directory of activemq data directory

 # httpd
$sslEnabled = true
$sslExcludeList = ["10.155.8.115","127.0.0.1","192.168.42.45"]

$httpRedirects = ["/ananya/ http://192.168.42.38:8080/ananya/"]
$httpsRedirects = ["/nagios http://192.168.42.45/nagios",
					"/ananyabatch http://192.168.42.45:8081/ananyabatch"]

$couchdbClusteringEnabled = true
$couchdbClusterPort = 8181
$couchdbPrimaryIp = "192.168.42.51"
$couchdbSecondaryIp = "192.168.42.52"


# https
$SSLCertificateFile = "/etc/pki/tls/certs/localhost.crt"
$SSLCertificateKeyFile = "/etc/pki/tls/private/localhost.key"

#ssh
$SSHPort = "12200"
$SSHPublicKeyFilePath = "" #Provide valid file path containing public key to be added to .ssh/authorized_keys.
$DeactivatePasswordAuthentication = false #true if password login to be enabled

#iptables configuration
$admin_access_ips = "127.0.0.1" #space seperated list of ips. example "11.1.1.1 2.2.2.2"
$ssh_allowed_ips = "0/0"  #space seperated list of ips. example "11.1.1.1 2.2.2.2"
$tcp_ports_open = "80 443" #List of ports that can be accessed from outside world.
$ssh_port = "22" #Port on which ssh daemon works.

#hostname configuration
$host_name="localhost"
$env="<environment>"

#nagios
$nagios_config_url = 'http://192.168.42.26:8080/job/Ananya-Delivery-Kilkari/lastStableBuild/org.motechproject.ananya$ananya-deploy/artifact/org.motechproject.ananya/ananya-deploy/0.2.1-SNAPSHOT/ananya-deploy-0.2.1-SNAPSHOT.jar'
$nagios_objects_path = "nagios/objects/"
$nagios_plugins_path = "nagios/plugins/"
$host_file_path = "properties/${env}/hosts.cfg" #env is the environment for nagios configuration

#keepalived
$machine_type = "MASTER" #Can be one of MASTER/SLAVE
$check_services_script_path = "/root/checkservices.sh" #Path of the script that will be executed at scheduled intervals. Should return 0 for success and 1 for failure.
$interface = "eth0"
$priority = "101" #Higher the priority the virtual ip address will be attached to that node
$virtual_ipaddress = "192.168.42.38/24" #Virtual ip address that is attached to the winning node

#Tomcat 7.0.22 configuration
$tomcatManagerUserName = "tomcat"
$tomcatManagerPassword = "p@ssw0rd"

 #--------------------------------RESOURCES--------------------------------------------
 # comment out resources not required to be installed

 # class{users : userName => "${motechUser}", password => "${motechPassword}" }
 # class{keepalived : machine_type => "${machine_type}", check_services_script_path => "${check_services_script_path}", interface => "${interface}", priority => "${priority}", virtual_ipaddress => "${virtual_ipaddress}"}
 # class{couchdb : couchReplicationSourceMachine => "${couchReplicationSourceMachine}", couchDbs => "${couchDbs}", couchInstallationMode => "${couchInstallationMode}", couchVersion => "${couchVersion}", couchDatabaseDir => "${couchDatabaseDir}"}
 # class{postgres : postgresUser => "${postgresUser}", postgresPassword => "${postgresPassword}", postgresMachine => "${postgresMachine}", postgresMaster => "${postgresMaster}", postgresSlave => "${postgresSlave}", os => "${os}", wordsize => "${word}"}
 # class{databackup : couchDbBackupLink => "${couchDbBackupLink}", postgresBackupLink => "${postgresBackupLink}", dataBackupDir => "${dataBackupDir}", machineType => "${machineType}"}
 # class { activemq : version => "5.5.1", activemqMachine => "${activemqMachine}", activemqMasterHost => "${activemqMasterHost}", activemqMasterPort => "${activemqMasterPort}", activemqDataDir => "${activemqDataDir}" }
 # class { iptables : admin_access_ips => "${admin_access_ips}", ssh_allowed_ips => "${ssh_allowed_ips}", tcp_ports_open => "${tcp_ports_open}", ssh_port => "${ssh_port}" }
 # class { hostname : host_name => "${host_name}" }
 # class { httpd : sslEnabled => $sslEnabled, sslCertificateFile => "${SSLCertificateFile}", sslCertificateKeyFile => "${SSLCertificateKeyFile}" }
 # class { "tomcat" : version => "7.0.22", userName => "${motechUser}", tomcatManagerUserName => "${tomcatManagerUserName}", tomcatManagerPassword => "${tomcatManagerPassword}"}
 # class { couchdblucene : version => "0.9.0-SNAPSHOT" }
 /*
 class { nagios :
    nagios_config_url => "${nagios_config_url}",
    nagios_objects_path => "${nagios_objects_path}",
    nagios_plugins_path => "${nagios_plugins_path}",
    host_file_path => "${host_file_path}"
 }
 */

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

