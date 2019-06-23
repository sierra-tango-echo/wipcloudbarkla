#LOCALIZATION
echo 'ZONE="Europe/London"' > /etc/sysconfig/clock
ln -snf /usr/share/zoneinfo/Europe/London /etc/localtime
yum -y install ntpdate

#BASE PACKAGES
yum -y install vim
