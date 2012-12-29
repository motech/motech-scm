unzip jasperserver.war -d jasperserver/
sed -i 's/^Validator.ValidSQL=.*/Validator.ValidSQL=(?is)^\\s*(select|with)\\s+[^;]+$/ ' jasperserver/WEB-INF/classes/esapi/validation.properties
cd jasperserver/ && zip -r ../jasperserver.war .
cd ../ && rm -rf jasperserver