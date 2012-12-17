#!/bin/sh

# to setup vm : wget https://raw.github.com/motech/motech-scm/master/bootstrap.sh && sh ./bootstrap.sh

#parameters:
# config=path/to/config/file
# debug=true
# help

#Globals:
CONFIG_FILE=$1
DEBUG="false"

usage() {
  echo "**** HELP ****"
  echo "Two main options: -c & -d"
  echo ""
  echo "./bootstrap.sh -c path/to/configuration.pp"
  echo "          This will run bootstrap the box with motech software according to configuration.pp"
  echo ""
  echo "./bootstrap.sh -d"
  echo "          This will run apply configuration via puppet in debug mode"
  echo ""
  echo "./bootstrap.sh -dc path/to/configuration.pp"
  echo "          You can provide both option parameters together"
  echo ""
  echo "./bootstrap.sh"
  echo "          Running without config (-c) option allows you to manually edit (via vi editor) the default configuration.pp before puppet apply"
  echo ""
  echo "./bootstrap.sh -h"
  echo "          Prints this"
}

ensurePuppetInstallation(){
  if ! type puppet > /dev/null 2>&1
  then
    arch=`uname -m`

    epelFileName=`curl --location 'http://ftp.jaist.ac.jp/pub/Linux/Fedora/epel/6/'$arch'/' | grep epel-release | sed -e 's/^.*\(epel.*rpm\).*$/\1/g'`

    rpmUrl="http://ftp.jaist.ac.jp/pub/Linux/Fedora/epel/6/$arch/$epelFileName"

    cd /tmp && rpm -ivh "$rpmUrl"

    yum -y install puppet
  fi
}

setConfigFileAbsolutePath() {
  locationPathFromRoot=`echo $CONFIG_FILE | cut -c 1 | grep / | wc -l`
  if [ $locationPathFromRoot -eq 0 ]; then
    CONFIG_FILE=`pwd`/$CONFIG_FILE
  fi
}


installGit() {
  yum -y install git
}


getMotechSCM() {
  cd /tmp/

  if [ ! -d /tmp/motech-scm/ ]; then
      git clone git://github.com/motech/motech-scm.git
  else
      cd /tmp/motech-scm/ && git reset --hard && git pull --rebase && cd /tmp/
  fi
}

setupPuppetConfiguration() {
  cd /tmp/motech-scm/puppet

  if [ -f $CONFIG_FILE ]; then
    cp $CONFIG_FILE manifests/nodes/configuration.pp
  else
    vi manifests/nodes/configuration.pp
  fi
}

puppetApply() {
  cd /tmp/motech-scm/puppet

  if [ "$DEBUG" = "true" ]; then
      puppet apply manifests/site.pp --debug --modulepath=modules/ && echo "Completed"
  else
      puppet apply manifests/site.pp --modulepath=modules/ && echo "Completed"
  fi
}

_main_() {
  ensurePuppetInstallation
  setConfigFileAbsolutePath
  installGit
  getMotechSCM
  setupPuppetConfiguration
  puppetApply
}

######### _main_ call #########
while getopts "c:dh" OPTION
  do
    case $OPTION in
      'c')
        CONFIG_FILE=$OPTARG
        ;;
      'd')
        DEBUG="true"
        ;;
      'h')
        usage
        exit 0
        ;;
    esac
  done

_main_

#############################