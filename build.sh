#-----------------Usage----------------------
# sudo -i
# sh builld.sh
# strings /etc/httpd/modules/mod_ssl.so | grep -i openssl
#-----------------Usage----------------------
# stop apache first
# take a backup of /etc/httpd
# then run the script

httpdVersion="2.4.29"
aprVersion="1.6.3"
pcreVersion="8.41"
openSSLversion="openssl-1.1.0g"
aprUtilVersion="1.6.1"

yum -y install wget perl gcc git subversion telnet expat-devel pcre-devel
TARGET_DIR="build"
if [ -d $TARGET_DIR ]; then
rm -rf /${TARGET_DIR}
fi
mkdir -p /${TARGET_DIR}/archives
OPENSSL_PATH="/usr"


cd /${TARGET_DIR}
git submodule update --init --recursive

wget http://ftp.nluug.nl/security/openssl/${openSSLversion}.tar.gz

tar -xvzf ${openSSLversion}.tar.gz
mv *.gz /${TARGET_DIR}/archives
mkdir -p /${TARGET_DIR}/apps
cd ${openSSLversion}
./config --prefix=/${OPENSSL_PATH} no-threads shared
echo "Building OPENSSL" >> .build.log
make clean
make test
make install
echo "Building OPENSSL completed" >> .build.log

cd /${TARGET_DIR}
wget "http://redrockdigimark.com/apachemirror//httpd/httpd-${httpdVersion}.tar.gz"
tar -xvzf "httpd-${httpdVersion}.tar.gz"
cd /${TARGET_DIR}
wget "http://redrockdigimark.com/apachemirror//apr/apr-${aprVersion}.tar.gz"
tar -xvzf apr-${aprVersion}.tar.gz
cp -r apr-${aprVersion} "/${TARGET_DIR}/httpd-${httpdVersion}/srclib/apr"

echo "Download and copy aprutil" >> .build.log

wget http://redrockdigimark.com/apachemirror//apr/apr-util-${aprUtilVersion}.tar.gz
tar -xvzf apr-util-${aprUtilVersion}.tar.gz
cp -r apr-util-${aprUtilVersion} "/${TARGET_DIR}/httpd-${httpdVersion}/srclib/apr-util"

wget https://ftp.pcre.org/pub/pcre/pcre2-${pcreVersion}.tar.gz

tar -xvzf pcre2-${pcreVersion}.tar.gz
cd /${TARGET_DIR}/pcre2-${pcreVersion}
echo "Under PCRE"
ls
./configure --prefix /${TARGET_DIR}/pcre
make clean && make install
echo "Building pcre completed" >> .build.log

cd /${TARGET_DIR}
yum install gcc-c++ zlib-devel -y

echo "Installing GCC" >> .build.log
cd /${TARGET_DIR}/pcre2-${pcreVersion}
echo "Present working directory $(pwd)"
./configure --prefix /${TARGET_DIR}/pcre

echo "Building pcre" >> .build.log
make clean && make install

cd "/${TARGET_DIR}/httpd-${httpdVersion}/"

echo "Building httpd" >> .build.log

echo "present ir is $(pwd)" >> /tmp/build.log
./configure --prefix=/etc/httpd --with-ssl=${OPENSSL_PATH}/ssl --enable-ssl=shared --enable-mods-shared=all --with-included-apr --with-pcre=/${TARGET_DIR}/pcre/bin/pcre2-config --enable-suexec --enable-mpms-shared=all --enable-systemd --enable-cgi   


make && make install
ln -s /etc/httpd/bin/apachectl /usr/bin/apachectl
ln -s /$TARGET_DIR/testssl.sh/testssl.sh  /usr/bin/testssl.sh

echo "completee" >> .build.log

