hostname=$1
echo "127.0.0.1     $hostname" >> /etc/hosts
sed -i 's/HOSTNAME.*/HOSTNAME='"$hostname"'/g' /etc/sysconfig/network 
hostname "$hostname"

