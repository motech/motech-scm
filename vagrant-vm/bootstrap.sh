boxImageLocation=$1
configurationFileLocation=$2

cd /tmp && \
cd /tmp/ && git clone git://github.com/motech/motech-scm.git -b incremental-development && \
cp $2 ./motech-scm/puppet/manifests/nodes && \
cp ./motech-scm/puppet/manifests/site.pp ./motech-scm/puppet/manifests/default.pp && \
cd ./motech-scm/puppet/ && \
vagrant box add centos6 $boxImageLocation && \
vagrant up
