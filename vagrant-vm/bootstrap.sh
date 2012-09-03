boxImageLocation=$1
configurationFileLocation=$2

centos6BoxExists=`vagrant box list | grep centos6 | wc -l`

if [ ! -d "/tmp/motech-scm" ]
then
  cd /tmp/ && git clone git://github.com/motech/motech-scm.git -b incremental-deployment
fi

cd /tmp/motech-scm
cp $configurationFileLocation ./puppet/manifests/nodes/configuration.pp
cp ./vagrant-vm/Vagrantfile ./puppet/
cd ./puppet/

if [ $centos6BoxExists -eq 0 ]
then
  vagrant box add centos6 $boxImageLocation && vagrant up
else
  vagrant destroy -f && vagrant up
fi
