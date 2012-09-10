publicKeyFilePath=$1;
motechUser=$2;

# If public key file is not provided, fail.
if [[ $publicKeyFilePath == "" ]]; then
        echo "Error: No public key file provided."
        exit 1;
fi

# If public key file does not exist, fail.
if [[ ! -f $publicKeyFilePath ]]; then
        echo "Error: Public key file $publicKeyFilePath does not exist.";
        exit 2;
fi

authorizedKeysFilePath="/home/$motechUser/.ssh/authorized_keys";

# Add public key to authorized keys file only if not already added.
if [[ ! -f $authorizedKeysFilePath || -z `grep -f $publicKeyFilePath $authorizedKeysFilePath` ]]; then
        echo "Adding public key to the $authorizedKeysFilePath file."
        cat $publicKeyFilePath >> $authorizedKeysFilePath;
else
        echo "Public key already exists. Skipping it."
fi
