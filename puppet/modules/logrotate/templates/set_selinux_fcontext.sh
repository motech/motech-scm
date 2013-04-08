fcontext_type=$1
target=$2
target_type=$3

if [ "$target_type" == "directory" ]
then
    target=`dirname $target`
fi

semanage fcontext -a -t $fcontext_type $target
restorecon -v $target