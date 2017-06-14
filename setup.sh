# install mysql
#yum -y install mysql-server mysql
#chkconfig --levels 235 mysqld on
#service mysqld start

yum -y install bash cairo cups-libs expat fontconfig keyutils-libs krb5-libs libpng libSM libX11 libXau libXdmcp libXext libXinerama libXrender mesa-libGL ntp openssl pam sysstat wget

cd /vagrant
wget https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-6-x86_64/pgdg-centos95-9.5-3.noarch.rpm
rpm -ivh pgdg-centos95-9.5-3.noarch.rpm
yum -y install postgresql95-server
/etc/init.d/postgresql-9.5 initdb

echo "local all all ident" > /var/lib/pgsql/9.5/data/pg_hba.conf
echo "host all all $(ip addr show dev eth0 | sed -nr 's/.*inet ([^ ]+).*/\1/p') md5" >> /var/lib/pgsql/9.5/data/pg_hba.conf
echo "host all all localhost md5" >> /var/lib/pgsql/9.5/data/pg_hba.conf

/etc/init.d/postgresql-9.5 start

cat <<EOF | su - postgres -c psql
create user core with password 'core';
create database core owner core encoding 'UTF-8';
create user eae with password 'eae';
create database eae owner eae encoding 'UTF-8';
create user analytics with password 'analytics';
create database analytics owner analytics encoding 'UTF-8';
EOF

chkconfig postgresql-9.5 on
	
yum -y install /vagrant/jive_sbs_employee-9.0.1.0.el6.x86_64.rpm

#https://static.jiveon.com/docconverter
wget https://static.jiveon.com/docconverter/jive_pdf2swf-0.9.1-a_RHEL_6.x86_64.rpm
rpm -ivh jive_pdf2swf-0.9.1-a_RHEL_6.x86_64.rpm

echo "net.core.rmem_max = 16777216" >> /etc/sysctl.conf
echo "net.core.wmem_max = 16777216" >> /etc/sysctl.conf
echo "net.ipv4.tcp_wmem = 4096 65536 16777216" >> /etc/sysctl.conf
echo "net.ipv4.tcp_rmem = 4096 87380 16777216" >> /etc/sysctl.conf
echo "vm.max_map_count = 2500442" >> /etc/sysctl.conf
sysctl -p

echo "    jive    soft    nofile  100000" >> /etc/security/limits.conf
echo "    jive    hard    nofile  200000" >> /etc/security/limits.conf

ln -s /etc/init.d/jive /usr/local/bin/jive

echo "$(ip addr show dev eth0 | sed -nr 's/.*inet ([^/]+).*/\1/p') vagrant-centos65.vagrantup.com vagrant-centos65" >> /etc/hosts

/etc/init.d/jive enable eae
/etc/init.d/jive enable cache
/etc/init.d/jive enable search
/etc/init.d/jive enable docconverter
/etc/init.d/jive enable webapp
/etc/init.d/jive enable httpd

/etc/init.d/jive set cache.hostnames vagrant-centos65

/etc/init.d/jive start
