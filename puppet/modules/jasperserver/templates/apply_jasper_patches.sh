unzip jasperserver.war -d jasperserver/
cd jasperserver
for patchFile in "$@"
do
    patch -p1 < $patchFile
done
zip -r ../jasperserver.war .
cd ../ && rm -rf jasperserver