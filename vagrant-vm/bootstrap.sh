boxImageLocation=$1
configurationFileLocation=$2
motechSCMLocation=$3

centos6BoxExists=`vagrant box list | grep centos6 | wc -l`
wd=`pwd`

if [ -d "/tmp/motech-scm" ]
then
  if [ -f "/tmp/motech-scm/puppet/.vagrant" ]
  then
    cd /tmp/motech-scm/puppet/ && vagrant destroy -f
  fi
  rm -rf /tmp/motech-scm
fi

cd $wd
cp -r $motechSCMLocation /tmp/
cd /tmp/motech-scm
cp $configurationFileLocation ./puppet/manifests/nodes/configuration.pp
cp ./vagrant-vm/Vagrantfile ./puppet/
cd ./puppet/

if [ $centos6BoxExists -eq 0 ]
then
  vagrant box add centos6 $boxImageLocation && vagrant up
else
  vagrant up
fi
