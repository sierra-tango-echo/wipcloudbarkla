_OF_PROFILE="${_OF_PROFILE:-slave}" #master, slave
_OF_SUBNETNETWORK="${_OF_SUBNETNETWORK:-10.12.168.0}"
_OF_SUBNETNETMASK="${_OF_SUBNETNETMASK:-255.255.248.0}"
_OF_MASTERIP="${_OF_MASTERIP:-10.12.168.128}"

NISDOMAIN='cluster'


if [ "$_OF_PROFILE" == "slave" ]; then
  yum -y install ypbind
  NISMASTER='10.110.0.11'
  echo "domain $NISDOMAIN server ${_OF_MASTERIP}" >> /etc/yp.conf
  nisdomainname $NISDOMAIN
  echo "NISDOMAIN=$NISDOMAIN" >> /etc/sysconfig/network
  sed -i -e 's/^passwd:.*/passwd:     files nis/g' \
    -e 's/^shadow:.*/shadow:     files nis/g' \
    -e 's/^group.*/group:      files nis/g' /etc/nsswitch.conf
  chkconfig ypbind on
  service ypbind restart
elif [ "$_OF_PROFILE" == "master" ]; then
  yum install -y ypserv yp-tools
  sed -e 's/^HOME.*$/HOME=\/users/g' -i  /etc/default/useradd
  echo "domain $NISDOMAIN server 127.0.0.1" >> /etc/yp.conf
  nisdomainname $NISDOMAIN
  echo "NISDOMAIN=$NISDOMAIN" >> /etc/sysconfig/network
  cat << EOF > /var/yp/securenets
host 127.0.0.1
${_OF_SUBNETNETMASK} ${_OF_SUBNETNETWORK}
EOF
  #Enable shadow passwords
  sed -e 's/^all.*$/all:  passwd group hosts rpc services netid protocols mail shadow \\/g' -e 's/^MERGE_PASSWD.*$/MERGE_PASSWD=false/g' -i /var/yp/Makefile
  echo -e "shadow\t\tshadow.byname" >> /var/yp/nicknames
  systemctl enable ypserv
  systemctl enable yppasswdd
  systemctl restart ypserv
  systemctl restart yppasswdd
fi

