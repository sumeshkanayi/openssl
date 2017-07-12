#-----------------Usage----------------------
# sudo -i
# sh builld.sh
# strings /etc/httpd/modules/mod_ssl.so | grep -i openssl
#-----------------Usage----------------------
httpdVersion="2.4.27"
aprVersion="1.6.2"
pcreVersion="10.23"
openSSLversion="1.1.0f"

yum -y install wget perl gcc git subversion telnet
TARGET_DIR="build"
if [ -d $TARGET_DIR ]; then
rm -rf /${TARGET_DIR}
fi
mkdir -p /${TARGET_DIR}/archives
OPENSSL_PATH="/usr"
OPENSSL="openssl-1.0.2k"
PCRE="8.35"
cd /${TARGET_DIR}

wget http://ftp.nluug.nl/security/openssl/${OPENSSL}.tar.gz

tar -xvzf ${OPENSSL}.tar.gz
mv *.gz /${TARGET_DIR}/archives
mkdir -p /${TARGET_DIR}/apps
cd ${OPENSSL}
./config --prefix=/${OPENSSL_PATH} no-threads shared
echo "Building OPENSSL" >> .build.log
make clean
make test
make install
echo "Building OPENSSL completed" >> .build.log

cd /${TARGET_DIR}
wget http://redrockdigimark.com/apachemirror//httpd/httpd-2.4.25.tar.gz
tar -xvzf httpd-2.4.25.tar.gz
cd /${TARGET_DIR}
wget http://redrockdigimark.com/apachemirror//apr/apr-1.5.2.tar.gz
tar -xvzf apr-1.5.2.tar.gz
cp -r apr-1.5.2 /${TARGET_DIR}/httpd-2.4.25/srclib/apr

echo "Download and copy aprutil" >> .build.log

wget http://redrockdigimark.com/apachemirror//apr/apr-util-1.5.4.tar.gz
tar -xvzf apr-util-1.5.4.tar.gz
cp -r apr-util-1.5.4 /${TARGET_DIR}/httpd-2.4.25/srclib/apr-util

wget https://ftp.pcre.org/pub/pcre/pcre-${PCRE}.tar.gz
tar -xvzf pcre-${PCRE}.tar.gz
cd /${TARGET_DIR}/pcre-${PCRE}
echo "Under PCRE"
ls
./configure --prefix /${TARGET_DIR}/pcre
make clean && make install
echo "Building pcre completed" >> .build.log

cd /${TARGET_DIR}
yum install gcc-c++ zlib-devel -y

echo "Installing GCC" >> .build.log
cd /${TARGET_DIR}/pcre-8.35
echo "Present working directory $(pwd)"
./configure --prefix /${TARGET_DIR}/pcre

echo "Building pcre" >> .build.log
make clean && make install

cd /${TARGET_DIR}/httpd-2.4.25/

echo "Building httpd" >> .build.log

echo "present ir is $(pwd)" >> /tmp/build.log
./configure --prefix=/etc/httpd --with-ssl=${OPENSSL_PATH}/ssl --enable-ssl=shared --enable-mods-shared=all --with-expat=builtin --with-included-apr --with-pcre=/${TARGET_DIR}/pcre/bin/pcre-config --enable-suexec --enable-mpms-shared=all --enable-systemd --enable-cgi   


make && make install

echo "completee" >> .build.log

