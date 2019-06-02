echo 'ZONE="Europe/London"' > /etc/sysconfig/clock
ln -snf /usr/share/zoneinfo/Europe/London /etc/localtime
yum -y install ntpdate

yum -y install vim

cat << "EOF" > /etc/profile.d/flightcenter.sh
#Custom PS1 with client name
[ -f /etc/flightcentersupported ] && c=32 || c=31
if [ "$PS1" ]; then
  PS1="[\u@\h\[\e[1;${c}m\][cloudbarkla]\[\e[0m\] \W]\\$ "
fi
EOF

touch /etc/flightcentersupported
