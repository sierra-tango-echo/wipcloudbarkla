yum -y install chrony
cat << EOF > /etc/chrony.conf
server 0.centos.pool.ntp.org iburst
server 1.centos.pool.ntp.org iburst
server 2.centos.pool.ntp.org iburst
server 3.centos.pool.ntp.org iburst

stratumweight 0

driftfile /var/lib/chrony/drift

rtcsync

makestep 10 3

bindcmdaddress 127.0.0.1
bindcmdaddress ::1

keyfile /etc/chrony.keys

commandkey 1

generatecommandkey

noclientlog

logchange 0.5

logdir /var/log/chrony

allow 10.210.0.0/16
EOF

systemctl enable chronyd
systemctl start chronyd
