source_httpd="/vagrant/mspidea1zips/mspidea/httpd"
source_apache2="/vagrant/mspidea1zips/mspidea/apache2"
mv  /etc/httpd/conf /etc/httpd/conf_backup
cp -r "${source_httpd}/conf" /etc/httpd
cp -r "${source_httpd}/sites-enabled" /etc/httpd
cp -r "${source_apache2}" /etc/
cp -r "${source_httpd}/conf.modules.d" /etc/httpd
if [ ! -e "/var/www/html" ]; then
mkdir -p /var/www/html
echo "<p>"Hello world"</p>" > /var/www/html/index.html
echo "<p>"Hello world "</p>" > /var/www/index.html

fi

#disable svn.conf

mv /etc/httpd/sites-enabled/svn.conf /etc/httpd/sites-enabled/svn.conf_backup



