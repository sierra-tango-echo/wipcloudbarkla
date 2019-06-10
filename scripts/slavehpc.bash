yum -y install nfs-utils
mkdir /opt/service
mount -t nfs cnfs1:/export/service /opt/service
bash /opt/service/alces/scripts/ALL01-base.bash
bash /opt/service/alces/scripts/SLAVE01-base.bash
bash /opt/service/alces/scripts/SLAVE90-ipa.bash
bash /opt/service/alces/scripts/HPC01-base.bash

bash /opt/service/alces/scripts/SLAVE99-nfs.bash
bash /opt/service/alces/scripts/HPC02-pkgs.bash
bash /opt/service/alces/scripts/SLAVE20-slurm_client.bash
bash /opt/service/alces/scripts/HPC15-barkla-pkgs.bash
bash /opt/service/alces/scripts/HPC20-flight-direct.bash
bash /opt/service/alces/scripts/HPC25-add-opt-apps-modules.bash
bash /opt/service/alces/scripts/HPC26-add-barkla-gridware-depot.bash
bash /opt/service/alces/scripts/HPC50-add-barkla-customizations.bash
