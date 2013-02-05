unzip jasperserver.war -d jasperserver/
cd jasperserver
for patchFile in "$@"
do
    patch -p1 < /tmp/jasper_patches/$patchFile.diff
done
zip -r ../jasperserver.war .
cd ../ && rm -rf jasperserver