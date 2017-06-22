#stop apache process
rm -rf /etc/httpd
rm -rf /etc/apache2
rm -rf /var/www
rm -rf /home/svn
rm -rf /var/log/apache2
rm -rf /etc/subversion
groupdel apache
userdel apach3
yum remove subversion mod_dav_svn
