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

cat << EOF > /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

10.210.1.101 gateway1.pri.barkla.alces.network gateway1.pri gateway1
10.210.1.102 clogin1.pri.barkla.alces.network clogin1.pri clogin1
10.210.2.101 cnode01.pri.barkla.alces.network cnode01.pri cnode01
10.210.2.102 cnode02.pri.barkla.alces.network cnode02.pri cnode02
10.210.2.103 cnode03.pri.barkla.alces.network cnode03.pri cnode03
10.210.2.104 cnode04.pri.barkla.alces.network cnode04.pri cnode04
10.210.2.105 cnode05.pri.barkla.alces.network cnode05.pri cnode05
10.210.2.106 cnode06.pri.barkla.alces.network cnode06.pri cnode06
10.210.2.107 cnode07.pri.barkla.alces.network cnode07.pri cnode07
10.210.2.108 cnode08.pri.barkla.alces.network cnode08.pri cnode08
10.210.2.109 cnode09.pri.barkla.alces.network cnode09.pri cnode09
10.210.2.110 cnode10.pri.barkla.alces.network cnode10.pri cnode10
10.210.2.111 cnode11.pri.barkla.alces.network cnode11.pri cnode11
10.210.2.112 cnode12.pri.barkla.alces.network cnode12.pri cnode12
10.210.2.113 cnode13.pri.barkla.alces.network cnode13.pri cnode13
10.210.2.114 cnode14.pri.barkla.alces.network cnode14.pri cnode14
10.210.2.115 cnode15.pri.barkla.alces.network cnode15.pri cnode15
10.210.2.116 cnode16.pri.barkla.alces.network cnode16.pri cnode16
10.210.2.117 cnode17.pri.barkla.alces.network cnode17.pri cnode17
10.210.2.118 cnode18.pri.barkla.alces.network cnode18.pri cnode18
10.210.2.119 cnode19.pri.barkla.alces.network cnode19.pri cnode19
10.210.2.120 cnode20.pri.barkla.alces.network cnode20.pri cnode20
10.210.2.121 cnode21.pri.barkla.alces.network cnode21.pri cnode21
10.210.2.122 cnode22.pri.barkla.alces.network cnode22.pri cnode22
10.210.2.123 cnode23.pri.barkla.alces.network cnode23.pri cnode23
10.210.2.124 cgpu01.pri.barkla.alces.network cgpu01.pri cgpu01
10.210.3.101 cinfra1.pri.barkla.alces.network cinfra1.pri cinfra1
10.210.4.101 cadmin01.pri.barkla.alces.network cadmin01.pri cadmin01
10.210.3.102 cnfs1.pri.barkla.alces.network cnfs1.pri cnfs1
10.10.0.25 infra1.pri.barkla.alces.network
EOF
