#strings mod_ssl.so | grep -i openssl
yum -y install wget perl gcc httpd git
TARGET_DIR="build"
mkdir -p /${TARGET_DIR}/archives
OPENSSL_PATH="/usr/openSSL1.0.2"
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
./configure --prefix /${TARGET_DIR}/pcre

echo "Building pcre" >> .build.log
make clean && make install

cd /${TARGET_DIR}/httpd-2.4.25/

echo "Building httpd" >> .build.log
./configure --prefix=/usr/apache --with-ssl=/${OPENSSL_PATH}/ssl --enable-ssl=shared --enable-mods-shared=all --with-expat=builtin --with-included-apr --with-pcre=/${TARGET_DIR}/pcre/bin/pcre-config 


make && make install

echo "completee" >> .build.log
