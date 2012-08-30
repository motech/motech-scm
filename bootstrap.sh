#!/bin/sh

# to setup vm : wget https://raw.github.com/motech/motech-scm/master/bootstrap.sh && sh ./bootstrap.sh path/to/configuration.pp

echo "MoTeCH: Bootstrap Machine:"
yum -y install git && \
cp $1 /tmp/configuration.pp && \
cd /tmp/ && git clone git://github.com/motech/motech-scm.git -b incremental-deployment && \
cd /tmp/motech-scm/puppet && mv /tmp/configuration.pp manifests/nodes/configuration.pp && \
puppet apply manifests/site.pp --modulepath=modules/ && echo "Completed"
