source_httpd="/source/httpd"
source_apache2="/source/apache2"
var_www="/source/www"
subversion_conf="/source/subversion"
mv  /etc/httpd/conf /etc/httpd/conf_backup
cp -r "${source_httpd}/conf" /etc/httpd
cp -r "${var_www}" /var
cp -r "${source_httpd}/sites-enabled" /etc/httpd
cp -r "${source_apache2}" /etc/
cp -r "${source_httpd}/conf.modules.d" /etc/httpd
cp -r "${source_httpd}/conf.d" /etc/httpd
cp ${subversion_conf}/*.* /etc/subversion

#test
groupadd apache
sudo useradd -d /var/www/html -g apache apache
mkdir -p /var/log/apache2

#touch mime.types ,try to copy it  from existing directory

touch /etc/mime.types

#add sed here 


mv /etc/httpd/conf.d/ssl.conf /etc/httpd/conf.d/ssl.conf_backup

yum -y install mod_dav_svn



#backup svn.conf

mv /etc/httpd/conf.modules.d/10-subversion.conf /etc/httpd/conf.modules.d/10-subversion.conf_backup

echo "LoadModule dav_svn_module    /usr/lib64/httpd/modules/mod_dav_svn.so" >> /etc/httpd/conf.modules.d/10-subversion.conf
echo "LoadModule authz_svn_module   /usr/lib64/httpd/modules/mod_authz_svn.so" >> /etc/httpd/conf.modules.d/10-subversion.conf

echo "# ADDING Missing modules" >> /etc/httpd/conf.modules.d/00-base.conf
echo "LoadModule authz_host_module modules/mod_authz_host.so" >> /etc/httpd/conf.modules.d/00-base.conf
echo "LoadModule authz_host_module modules/mod_access_compat.so" >> /etc/httpd/conf.modules.d/00-base.conf
echo "LoadModule setenvif_module modules/mod_setenvif.so" >> /etc/httpd/conf.modules.d/00-base.conf
echo "LoadModule authz_core_module modules/mod_authz_core.so" >> /etc/httpd/conf.modules.d/00-base.conf
echo "LoadModule unixd_module modules/mod_unixd.so" >> /etc/httpd/conf.modules.d/00-base.conf
echo "LoadModule deflate_module modules/mod_deflate.so" >> /etc/httpd/conf.modules.d/00-base.conf
echo "LoadModule dumpio_module modules/mod_dumpio.so" >> /etc/httpd/conf.modules.d/00-base.conf
echo "LoadModule headers_module modules/mod_headers.so" >> /etc/httpd/conf.modules.d/00-base.conf
echo "LoadModule log_config_module modules/mod_log_config.so" >> /etc/httpd/conf.modules.d/00-base.conf

echo "Listen 443" >> /etc/httpd/conf/httpd.conf

mv /etc/httpd/conf.modules.d/00-systemd.conf /etc/httpd/conf.modules.d/00-systemd.conf_backup

