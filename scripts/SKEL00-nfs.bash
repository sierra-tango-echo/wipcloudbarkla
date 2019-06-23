_OF_PROFILE="${_OF_PROFILE:-slave}" #master, slave
_OF_SUBNETCIDR="${_OF_SUBNETCIDR:-10.12.168.0/21}"
_OF_MASTERIP="${_OF_MASTERIP:-10.12.168.128}"

if [ "$_OF_PROFILE" == "slave" ]; then
  yum -y install nfs-utils
  cat << EOF >> /etc/fstab
${_OF_MASTERIP}:/opt/service    /opt/service    nfs    noauto,intr,_netdev,vers=3    0 0
EOF
  mkdir -p /opt/service
  mount -t nfs -a
elif [ "$_OF_PROFILE" == "master" ]; then
  yum -y install nfs-utils
  sed -ie "s/^#\RPCNFSDCOUNT.*$/\RPCNFSDCOUNT=32/g" /etc/sysconfig/nfs
  cat << EOF > /etc/exports 
/opt/service ${_OF_SUBNETCIDR}(rw,no_root_squash,sync)
EOF
  systemctl enable nfs
  systemctl restart nfs
fi

