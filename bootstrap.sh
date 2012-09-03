#!/bin/sh

# to setup vm : wget https://raw.github.com/motech/motech-scm/master/bootstrap.sh && sh ./bootstrap.sh path/to/configuration.pp

configurationFileLocation=$1
locationPathFromRoot=`echo $configurationFileLocation | cut -c 1 | grep / | wc -l`

if [ $locationPathFromRoot -eq 0 ]
then
  configurationFileLocation=`pwd`/$configurationFileLocation
fi

echo "MoTeCH: Bootstrap Machine:"
yum -y install git && \
cd /tmp/ && git clone git://github.com/motech/motech-scm.git -b incremental-deployment && \
cd /tmp/motech-scm/puppet && cp $configurationFileLocation manifests/nodes/configuration.pp && \
puppet apply manifests/site.pp --modulepath=modules/ && echo "Completed"
