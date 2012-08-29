#!/bin/sh

# to setup vm : wget https://raw.github.com/motech/motech-scm/master/bootstrap.sh && sh ./bootstrap.sh 

echo "MoTeCH: Bootstrap Machine:"

yum -y install puppet && yum -y install git && \
cd /tmp/ && git clone git://github.com/motech/motech-scm.git && \
cd /tmp/motech-scm/puppet && vi manifests/nodes/configuration.pp && \
puppet apply manifests/site.pp --modulepath=modules/ && echo "Completed"
