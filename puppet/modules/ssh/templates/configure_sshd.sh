port=$1
motechUser=$2
DeactivatePasswordAuthentication=$3
configFile=/etc/ssh/sshd_config

findAndReplace()
{
    if [[ -z `grep ^$1 $configFile` ]]
    then
        echo $1 $2 >> $configFile
    else
        sed -i "s/^$1\\t* .*/$1 $2/" $configFile
    fi
}

findAndReplace "Port" "$port"
findAndReplace "PermitRootLogin" "no"
findAndReplace "X11Forwarding" "no"
findAndReplace "AllowUsers" "$motechUser"

if $DeactivatePasswordAuthentication
then
    findAndReplace "PasswordAuthentication" "no"
fi
