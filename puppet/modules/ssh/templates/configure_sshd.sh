port=$1
publicKeyFilePath=$2
motechUser=$3
DeactivatePasswordAuthentication=$4
configFile=/etc/ssh/sshd_config

sed -i 's/#\(Port\)\ \([0-9]*\)/\1\ '$port'/' $configFile

sed -i 's/#*\(PermitRootLogin\)\ .*/\1\ no/' $configFile

if $DeactivatePasswordAuthentication
then
    sed -i 's/^\(PasswordAuthentication\) \(yes\)/\1 no/' $configFile
fi

sed -i 's/^\(X11Forwarding\)\ \(yes\)/\1 no/' $configFile

if [-z `grep -e "AllowUsers" -f $configFile` ]
then
    sed -i '${/^$/!s/$/\
    AllowUsers motech/;}' $configFile
fi

cat $publicKeyFilePath >> /home/$motechUser/.ssh/authorized_keys