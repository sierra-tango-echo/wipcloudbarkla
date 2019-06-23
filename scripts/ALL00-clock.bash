yum -y install chrony

_OF_PROFILE="${_OF_PROFILE:-slave}" #master, slave
_OF_SUBNETCIDR="${_OF_SUBNETCIDR:-10.12.168.0/21}"

if [ "$_OF_PROFILE" == "slave" ]; then
cat << EOF > /etc/chrony.conf
server gateway1 iburst

driftfile /var/lib/chrony/drift
makestep 360 10
EOF
elif [ "$_OF_PROFILE" == "master" ]; then
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

allow $_OF_SUBNETCIDR
EOF
fi
systemctl enable chronyd
systemctl start chronyd
