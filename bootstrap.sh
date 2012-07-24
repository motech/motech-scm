#!/bin/sh

# to setup vm : wget https://raw.github.com/motech/motech-scm/master/bootstrap.sh && sh ./bootstrap.sh 

echo "MoTeCH: Bootstrap Machine:"

# Fetching the latest epel-release rpm name
epelFileName=curl --location 'http://ftp.jaist.ac.jp/pub/Linux/Fedora/epel/6/x86_64/' | grep epel-release | sed -e 's/^.*\(epel.*rpm\).*$/\1/g'

rpmUrl="http://ftp.jaist.ac.jp/pub/Linux/Fedora/epel/6/"`uname -m`"/$epelFileName"
echo "Using epel release 6 : $rpmUrl"
cd /tmp && rpm -ivh "$rpmUrl"
yum -y install puppet && yum -y install git && \
cd /tmp/ && git clone git://github.com/motech/motech-scm.git && \
cd /tmp/motech-scm/puppet && vi manifests/nodes/configuration.pp && \
puppet apply manifests/site.pp --modulepath=modules/ && echo "Completed!"
