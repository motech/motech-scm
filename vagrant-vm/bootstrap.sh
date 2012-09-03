boxImageLocation=$1
configurationFileLocation=$2

cd /tmp/ && git clone git://github.com/motech/motech-scm.git -b incremental-deployment && \
cd ./motech-scm && git checkout incremental-deployment && \
cp $2 ./puppet/manifests/nodes/configuration.pp && \
cp ./puppet/manifests/site.pp ./motech-scm/puppet/manifests/default.pp && \
cp ./vagrant-vm/Vagrantfile ./puppet/ && \
cd ./puppet/ && \
vagrant box add centos6 $boxImageLocation && \
vagrant up
