if hostname -s | grep -q login; then
  yum install -y -e0 libxml2-devel screen prelink tcsh \
    gstreamer1-devel-docs gstreamer1-devel gstreamer1
fi

yum install -y -e0 gnuplot bc java-1.8.0-openjdk-devel python2-pip \
  dos2unix libpsm2-devel ksh nco votca-csg compat-libstdc++-33 \
  redhat-lsb-core proj-devel proj-epsg proj-nad proj proj-static \
  libarchive-devel lua-devel lzo-devel tcsh libicu-devel
