#!/bin/bash
# Check if Slurm is already installed

if [ -d /etc/slurm ] ; then
   echo "Slurm directory already exists - remove /etc/slurm and re-run"
   exit 1
fi

pushd /opt/service/alces/files/rpms
yum -y install epel-release
yum -y install munge munge-devel munge-libs perl-Switch 
yum -y -e0 localinstall slurm-*.rpm
popd

# Install munge key and start+enable service
cp /opt/service/alces/files/munge.key /etc/munge/munge.key
chmod 400 /etc/munge/munge.key
chown munge /etc/munge/munge.key

systemctl enable munge
systemctl start munge

# Setup slurm; start and enable service
mkdir /var/log/slurm
chown nobody /var/log/slurm

scp /opt/service/alces/files/slurm.conf /etc/slurm/slurm.conf
scp /opt/service/alces/files/gres.conf /etc/slurm/gres.conf

systemctl enable slurmd
systemctl restart slurmd
