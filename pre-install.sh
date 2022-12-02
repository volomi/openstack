#!/bin/bash

# Version 1.0


echo ""
echo ""
echo "*************************************************************************************"
echo "****************************** OPEN STACK INSTALLATION ******************************"
echo "************************************************************************version-1.0**"
echo ""
echo ""


echo "Installing Dependencies ........."
sleep 3


echo "Installing Chrony Service"

yum install chrony vim -y


echo "Starting the Service"

systemctl enable chronyd.service


echo -n "Enter IP [ ens33 ]: "
read ens33IPADD

cat >> /etc/chrony.conf << EOL
server $ens33IPADD iburst
EOL

systemctl restart chronyd.service


echo "Enabling OpenStack Repository"
sleep 2

yum install centos-release-openstack-rocky -y


yum upgrade -y


yum update -y


echo "Installing python-openstackclient"
sleep 2
yum install python-openstackclient -y



echo "Installing SElinux Package"
sleep 2
yum install openstack-selinux -y


sed -i 's/enforcing/disabled/g' /etc/selinux/config
setenforce 0
sestatus


echo "Disabling Firewall/NetworkManager"
sleep 2

systemctl stop firewalld.service
systemctl disable firewalld.service
systemctl stop NetworkManager.service
systemctl disable NetworkManager.service


cat >> /etc/hosts <<EOL
$ens33IPADD	rocky.thecloudenabled.com	rocky
EOL


cat > /etc/hostname <<EOL
rocky
EOL


echo "Setting Hostname......"
sleep 2

hostname rocky

echo "verifying...."
sleep 3
hostname --fqdn
echo ""



echo "Modifying Interfaces File : We need Uuu.."
sleep 2


bash ipconfigs.sh


echo "Install Openvswitch Package/Enabling ...."
sleep 2

yum install openstack-neutron-openvswitch -y
systemctl enable openvswitch.service
systemctl start openvswitch.service


echo "Note: If you are using Putty/Mobaxterm it will stop working after 5 min, make sure you use init 6 command for restart"

sleep 9

ovs-vsctl add-br br-ex
ovs-vsctl add-port br-ex ens33


