#!/bin/bash

# Globals Start
option=$1
myDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
commonPP="$myDir/common.pp"
modulesDir="$myDir/../puppet/modules"
manifestsDir="$myDir"
# Globals End

# Functions Start
setup_vagrantfile(){
  sed '/^  config.vm.box = ".*"$/ a\
    config.vm.provision :puppet, :module_path => "'$modulesDir'", :options => "--verbose --debug", :manifests_path => "'$manifestsDir'", :manifest_file => "common.pp"
  ' Vagrantfile > Vagrantfile.bk
  mv Vagrantfile{.bk,}
}

init(){
  clear

  local boxFile=$1
  local configFile=$2
  local boxFileName=${boxFile##*/}

  cd $myDir
  vagrant box add $boxFileName $boxFile && echo "VM added"
  vagrant init $boxFileName && echo "Vagrantfile created"
  setup_vagrantfile && echo "Vagrantfile setup done"

  cp $commonPP{,.bk} && echo "common.pp backed-up"
  cat $configFile >> $commonPP && echo "common.pp prepared"
}

clear(){
  if [ -f Vagrantfile ]; then
    local boxFileName=`grep "  config.vm.box" Vagrantfile | sed 's/.*\"\(.*\)\"/\1/g'`
    local boxExists=`vagrant box list | grep $boxFileName | wc -l`
    local boxRunning=`vagrant status | grep default | grep running | wc -l`

    [[ ! boxRunning -eq 0 ]] && vagrant destroy -f && echo "VM destroyed"
    [[ ! boxExists -eq 0 ]] && vagrant box remove $boxFileName && echo "VM removed"

    rm Vagrantfile && echo "Vagrantfile removed"
  fi

  [[ -f $commonPP".bk" ]] && mv $commonPP{.bk,} && echo "common.pp restored"
}

usage(){
  echo "**** HELP ****"
  echo "1) Make sure you are in vagrant-vm folder"
  echo "2) Run: <sh bootstap.sh /path/to/image.box /path/to/configuration.pp> This creates Vagrantfile and initiates vagrant"
  echo "3) From with-in vagrant-vm execute vagrant up/destroy/package to test your changes in motech-scm/puppet/modules or configuration.pp"
  echo "4) Run: <sh bootstrap.sh clear> to delete extra created files and destroy vagrant"
}
# Functions End

case $option in
  "init")
    init $2 $3
  ;;
  "clear")
    clear
  ;;
  "help")
    usage
  ;;
  *)
    usage
  ;;
esac