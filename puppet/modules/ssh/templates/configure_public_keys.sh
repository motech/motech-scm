publicKeyFilePath=$1
motechUser=$2

#add public keys to authorized keys if does not exist
if [[ -z `grep -f $publicKeyFilePath /home/$motechUser/.ssh/authorized_keys` ]]
then
    cat $publicKeyFilePath >> /home/$motechUser/.ssh/authorized_keys
fi