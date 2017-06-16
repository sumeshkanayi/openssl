source_httpd="/vagrant/mspidea1zips/mspidea/httpd"
source_apache2="/vagrant/mspidea1zips/mspidea/apache2"
mv  /etc/httpd/conf /etc/httdpd/conf_backup
cp -r "${source_httpd}/conf" /etc/httpd
cp -r "${source_httpd}/sites-*" /etc/httpd
cp -r "${source_apache2}" /etc/



