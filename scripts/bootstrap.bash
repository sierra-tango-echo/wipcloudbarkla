export _OF_MASTERIP="${_OF_MASTERIP:-10.12.168.128}"
userdel alces-cluster
yum -y install nfs-utils
mkdir /opt/service
mount -t nfs ${_OF_MASTERIP}:/opt/service /opt/service

bash /opt/service/alces/scripts/ALL00-base.bash
bash /opt/service/alces/scripts/ALL00-clock.bash
bash /opt/service/alces/scripts/ALL00-profile.bash
bash /opt/service/alces/scripts/SKEL00-nfs.bash
bash /opt/service/alces/scripts/SKEL00-nis.bash
bash /opt/service/alces/scripts/SKEL00-pdsh.bash
