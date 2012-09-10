#!/bin/bash

# Globals Start
option=$1
myDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
commonPP="$myDir/common.pp"
modulesDir="$myDir/../puppet/modules"
manifestsDir="$myDir"
vmPropertiesFile="$myDir/.testvm.properties"
# Globals End

# Functions Start
setup_vagrantfile(){
  sed '/^  config.vm.box = ".*"$/ a\
    config.vm.provision :puppet, :module_path => "'$modulesDir'", :options => "--verbose --debug", :manifests_path => "'$manifestsDir'", :manifest_file => "config.pp"
  ' Vagrantfile > Vagrantfile.bk
  mv Vagrantfile{.bk,}
}

load_config(){
  local configFile=$1

  cp $commonPP config.pp && echo "created config.pp from common.pp"
  cat $configFile >> config.pp && echo "application config added to config.pp"
}

reload_config(){
  if [ -f $vmPropertiesFile ]; then
    local configFile=`cat $vmPropertiesFile | grep configFile | cut -d":" -f2`
    [[ -f $configFile ]] && load_config $configFile && echo "reloaded configFile{:$configFile}"
  fi
}

save_config_file_path(){
  local configFile=$1
  echo "configFile:$configFile" > $vmPropertiesFile && echo "saved path to configFile{:$configFile}"
}

init(){
  clear

  local boxFile=$1
  local configFile=$2
  local boxFileName=${boxFile##*/}

  cd $myDir
  command vagrant box add $boxFileName $boxFile && echo "VM added"
  command vagrant init $boxFileName && echo "Vagrantfile created"
  setup_vagrantfile && echo "Vagrantfile setup done"

  save_config_file_path $configFile
  load_config $configFile
}

clear(){
  if [ -f Vagrantfile ]; then
    local boxFileName=`grep "  config.vm.box" Vagrantfile | sed 's/.*\"\(.*\)\"/\1/g'`
    local boxExists=`command vagrant box list | grep $boxFileName | wc -l`
    local boxDestroyed=`command vagrant status | grep default | grep "not created" | wc -l`

    [[ boxDestroyed -eq 0 ]] && command vagrant destroy -f && echo "VM destroyed"
    [[ ! boxExists -eq 0 ]] && command vagrant box remove $boxFileName && echo "VM removed"
    
    rm Vagrantfile && echo "Vagrantfile removed"
  fi

  [[ -f config.pp ]] && rm -f config.pp && echo "config.pp removed"
  [[ -f $vmPropertiesFile ]] && rm -f $vmPropertiesFile && echo ".testvm.properties deleted"
}

usage(){
  echo "**** HELP ****"
  echo "1) Make sure you are in vagrant-vm folder"
  echo "2) Run: <sh bootstap.sh init /path/to/image.box /path/to/configuration.pp> This creates Vagrantfile and initiates vagrant"
  echo "3) From with-in vagrant-vm execute vagrant up/halt/reload/package (http://tinyurl.com/d4ljaxm) to test your changes in motech-scm/puppet/modules or configuration.pp or Vagrantfile"
  echo "4) Run: <sh bootstrap.sh clear> to delete extra created files and destroy vagrant"
}

vagrant(){
  if [ ! -z `echo "up reload" | grep -o $1` ]; then
    reload_config
  fi
  command vagrant $@
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
