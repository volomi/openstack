#!/bin/bash

echo ""
echo "****************************************************************"
echo "******************** MYSQL INSTALLATION ************************"
echo "***************************************************version.1.0**"
echo ""

sleep 3

echo "Installing Dependencies...."
sleep 2

yum install mariadb mariadb-server python2-PyMySQL -y

systemctl enable mariadb.service
systemctl start mariadb.service


echo ""
echo "We need your help to setting Up!!"
echo ""

mysql_secure_installation


echo ""

cat > /etc/my.cnf.d/openstack.cnf <<EOL
[mysqld]
bind-address = 0.0.0.0
default-storage-engine = innodb
innodb_file_per_table = on
max_connections = 4096
collation-server = utf8_general_ci
character-set-server = utf8
EOL


echo ""
echo "Restarting Mariadb Server"
sleep 2
systemctl restart mariadb.service


echo ""
echo "Installing RabbitMQ ......"
sleep 3
yum -y install rabbitmq-server
systemctl enable rabbitmq-server.service
systemctl start rabbitmq-server.service

echo ""
echo "Add the Openstack user for rabbitmq Server"
echo ""

echo "Enter Username [eg, rabbit]: "
read user

rabbitmqctl add_user openstack $user


echo ""
echo "Permitting the Access!!"
sleep 2
rabbitmqctl set_permissions openstack ".*" ".*" ".*"

echo "Installing Memcached packages!!"
sleep 2
yum install memcached python-memcached python-openstackclient -y

bash memcached.sh

systemctl enable memcached.service
systemctl start memcached.service

echo "Success: Installed MySQL!!"

