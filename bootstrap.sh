#!/bin/sh

# to setup vm : wget https://raw.github.com/motech/motech-scm/master/bootstrap.sh && sh ./bootstrap.sh 

echo "MoTeCH: Bootstrap Machine:"
# epel-release version keeps changing on the website. You might need to update to the latest version.
# Or, you could curl the parent directory, parse epel-release* and then fetch the current version.
rpmUrl="http://ftp.jaist.ac.jp/pub/Linux/Fedora/epel/6/"`uname -m`"/epel-release-6-7.noarch.rpm"
echo "Using epel release 6 : $rpmUrl"
cd /tmp && rpm -ivh "$rpmUrl"
yum -y install puppet && yum -y install git && \
cd /tmp/ && git clone git://github.com/motech/motech-scm.git && \
cd /tmp/motech-scm/puppet && vi manifests/nodes/configuration.pp && \
puppet apply manifests/site.pp --modulepath=modules/ && echo "Completed!"
