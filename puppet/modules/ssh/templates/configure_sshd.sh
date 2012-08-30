port=$1
publicKeyFilePath=$2
motechUser=$3

sed -i 's/#\(port\)\ \(\d*\)/\1\ \{\$port\}/' /etc/ssh/sshd_config
sed -i 's/^\(PasswordAuthentication\) \(yes\)/\1 no/' /etc/ssh/sshd_config
sed -i 's/^\(X11Forwarding\)\ \(yes\)/\1 no/' /etc/ssh/sshd_config
sed -i '${/^$/!s/$/\
AllowUsers motech\
PermitRootLogin no/;}' /etc/ssh/sshd_config

cat publicKeyFilePath >> /home/${motechUser}/.ssh/authorized_keys