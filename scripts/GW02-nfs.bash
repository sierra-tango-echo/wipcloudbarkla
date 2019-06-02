yum -y install nfs-utils
sed -ie "s/^#\RPCNFSDCOUNT.*$/\RPCNFSDCOUNT=32/g" /etc/sysconfig/nfs

cat << EOF > /etc/exports 
/opt/service 10.210.0.0/16(rw,no_root_squash,sync)
EOF

systemctl enable nfs
systemctl restart nfs
