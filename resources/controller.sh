#!/bin/bash 
set -x
source /vagrant/resources/controller.cfg
sudo su  - <<SUDO

function packages(){
yum -y install epel-release.noarch centos-release-openstack-queens  && \
yum --enablerepo=centos-openstack-queens -y install mariadb-server &&  \
yum --enablerepo=centos-openstack-queens,epel -y install openstack-keystone openstack-utils python-openstackclient httpd mod_wsgi
yum --enablerepo=epel -y install rabbitmq-server memcached wget 
yum --enablerepo=centos-openstack-queens,epel -y install openstack-glance
}

#Install RabbitMQ
function rabbit_config() {
systemctl start rabbitmq-server memcached && \
systemctl enable rabbitmq-server memcached && \
rabbitmqctl add_user openstack password && \
rabbitmqctl set_permissions openstack ".*" ".*" ".*"

if [ $FIREWALLD == yes ]; then
 firewall-cmd --add-port={11211/tcp,5672/tcp} --permanent
 firewall-cmd --reload
fi
}

function mysql_start(){
mysqladmin -u root password "$DBPASS";
systemctl start mariadb
mysql -u root -p"$DBPASS" -e "UPDATE mysql.user SET Password=PASSWORD('$DBPASS') WHERE User='root'"
mysql -u root -p"$DBPASS" -e "DELETE FROM mysql.user WHERE User=''"
mysql -u root -p"$DBPASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
mysql -u root -p"$DBPASS" -e "FLUSH PRIVILEGES"
grep "bind-address" /etc/my.cnf

if [ $? == 1 ]; then
echo "bind-address='${MYSQLHOST}'" >> /etc/my.cnf
else
echo "mysql bind is set"
fi

systemctl restart mariadb

if [ $FIREWALLD == yes ]; then
 firewall-cmd --add-port={3306/tcp} --permanent
 firewall-cmd --reload
fi
}


function mysql_keystone(){

mysql -u root -p$DBPASS <<KEYSTONEDB
CREATE DATABASE IF NOT EXISTS keystone;
KEYSTONEDB
mysql -u root -p$DBPASS <<KEYSTONEDBUSER
GRANT ALL ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '$KEYSTONEDBPASS';
GRANT ALL ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '$KEYSTONEDBPASS';
FLUSH PRIVILEGES;
KEYSTONEDBUSER

until mysql -u keystone  -p$KEYSTONEDBPASS  -e ";" ; do
       read -p "Keystone DB error"
	exit 0
done
}


function keystone_config(){
cp -Rv /etc/keystone/keystone.conf /etc/keystone/keystone.conf.ORIG$(date)
cp -Rv /vagrant/resources/templates/keystone.conf /etc/keystone
cp -Rv /vagrant/resources/templates/wsgi-keystone.conf /etc/httpd/conf.d
sed -i 's/CONTROLLER/'${CONTROLLER}'/g' /etc/httpd/conf.d/wsgi-keystone.conf
sed -i 's/KEYSTONEPASSVAR/'$KEYSTONEDBPASS'/g' /etc/keystone/keystone.conf
sed -i 's/MYSQLVARHOST/'$MYSQLHOST'/g' /etc/keystone/keystone.conf
sed -i 's/MEMCACHEVARHOST/'$MEMCACHEHOST'/g' /etc/keystone/keystone.conf

until su -s /bin/bash keystone -c "keystone-manage db_sync" ";" ; do
       read -p "Keystone db_sync error"
        exit 0
done


if [ $? == 0 ]; then 
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone 
fi 

if [ $? == 0 ]; then 
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone 
fi 

keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
keystone-manage bootstrap --bootstrap-password keystone \
                --bootstrap-admin-url http://$CONTROLLER:5000/v3/ \
                --bootstrap-internal-url http://$CONTROLLER:5000/v3/ \
                --bootstrap-public-url http://$CONTROLLER:5000/v3/ \
                --bootstrap-region-id RegionOne

if [ $SELINUX == yes ]; then
setsebool -P httpd_use_openstack on
setsebool -P httpd_can_network_connect on
setsebool -P httpd_can_network_connect_db on
fi

if [ $FIREWALLD == yes ]; then
firewall-cmd --add-port=5000/tcp --permanent 
firewall-cmd --reload
fi

if [ $? == 0 ]; then
systemctl restart httpd
systemctl enable
fi

if [ -f /tmp/keystone.rc ]; then
echo "keystone source file exist"
else
cat >/tmp/keystone.rc<<KEYSTONEFILE
export OS_PROJECT_DOMAIN_NAME=default
export OS_USER_DOMAIN_NAME=default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=keystone
export OS_AUTH_URL=http://'${CONTROLLER}':5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
export PS1='[\u@\h \W(keystone)]\$ '
KEYSTONEFILE
echo "The Keystone source file : /tmp/keystone.rc"
fi
source /tmp/keystone.rc
openstack project list | grep service
if [ $? == 1 ] ; then
openstack project create --domain default --description "Service Project" service
	if [ $? == 0 ] ; then
		echo "Endpoint is ok"
		else
		echo "Endpoint error - check the deployment"
		exit 0 
	fi

else
echo "project service exist"
fi
}

packages
rabbit_config

systemctl status mariadb >> /dev/null
if [ $? == 1 ]; then 
mysql_start
fi 

mysql_keystone
keystone_config
SUDO

