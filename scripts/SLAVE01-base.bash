yum -y install chrony
cat << EOF > /etc/chrony.conf
server gateway1 iburst

driftfile /var/lib/chrony/drift
makestep 360 10
EOF
systemctl enable chronyd
systemctl start chronyd
