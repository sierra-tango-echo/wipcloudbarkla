yum -y install nfs-utils
sed -ie "s/^#\RPCNFSDCOUNT.*$/\RPCNFSDCOUNT=32/g" /etc/sysconfig/nfs

cat << EOF > /etc/exports 
/export/users 10.210.0.0/16(rw,no_root_squash,sync)
/export/service 10.210.0.0/16(rw,no_root_squash,sync)
/export/apps 10.210.0.0/16(rw,no_root_squash,sync)
/export/site 10.210.0.0/16(rw,no_root_squash,sync)
/export/gridware 10.210.0.0/16(rw,no_root_squash,sync)
EOF

systemctl enable nfs
systemctl restart nfs
