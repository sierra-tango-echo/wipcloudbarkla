_OF_CLUSTERNAME="${_OF_CLUSTERNAME:-arc4}"

echo "CLUSTERNAME=\"$_OF_CLUSTERNAME\"" > /etc/profile.d/flightcenter.sh
cat << "EOF" >> /etc/profile.d/flightcenter.sh
#Custom PS1 with cluster name
[ -f /etc/flightcentersupported ] && c=32 || c=31
if [ "$PS1" ]; then
  PS1="[\u@\h\[\e[1;${c}m\][$CLUSTERNAME]\[\e[0m\] \W]\\$ "
fi
EOF

touch /etc/flightcentersupported
