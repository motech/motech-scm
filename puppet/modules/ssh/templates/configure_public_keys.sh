publicKeyFilePath=$1
motechUser=$2

#add public keys to authorized keys if does not exist
for key in `cat $publicKeyFilePath`
do
    if [[ -z `grep $key /home/$motechUser/.ssh/authorized_keys` ]]
    then
        cat $key >> /home/$motechUser/.ssh/authorized_keys
    fi
done