arch=`uname -m`
epelFileName=`curl --location 'http://ftp.jaist.ac.jp/pub/Linux/Fedora/epel/6/'$arch'/' | grep epel-release | sed -e 's/^.*\(epel.*rpm\).*$/\1/g'`
rpmUrl="http://ftp.jaist.ac.jp/pub/Linux/Fedora/epel/6/$arch/$epelFileName"

wget -O /tmp/epel-release.rpm $rpmUrl