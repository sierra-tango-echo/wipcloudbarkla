cat << EOF > /etc/resolv.conf
search pri.barkla.alces.network barkla.alces.network
nameserver 10.210.0.2
EOF

echo "10.10.0.25	infra1.pri.barkla.alces.network" >> /etc/hosts

yum -y install ipa-client
ipa-client-install --no-ntp --mkhomedir --no-ssh --force-join --realm="PRI.BARKLA.ALCES.NETWORK" --server="cinfra1.pri.barkla.alces.network" -w "liugJac1" --domain="pri.barkla.alces.network" --unattended --hostname="`hostname -s`.pri.barkla.alces.network"
