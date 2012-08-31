port=$1
motechUser=$2
DeactivatePasswordAuthentication=$3
configFile=/home/motech/temp/sshd_config

findAndReplace()
{
    if [[ -z `grep "^\s*$1\>" $configFile` ]]
    then
        echo $1 $2 >> $configFile
    else
        sed -i "s/^\s*$1\>.*/$1 $2/" $configFile
    fi
}

findAndReplace "Port" "$port"
findAndReplace "PermitRootLogin" "no"
findAndReplace "X11Forwarding" "no"
findAndReplace "AllowUsers" "$motechUser"

if [ "$DeactivatePasswordAuthentication" == "true" ]
then
    findAndReplace "PasswordAuthentication" "no"
fi