if ! grep -q '/opt/gridware/barkla/$cw_DIST/etc/modules' /opt/flight-direct/etc/modulerc/modulespath; then
  echo >> /opt/flight-direct/etc/modulerc/modulespath
  echo '/opt/gridware/barkla/$cw_DIST/etc/modules' >> /opt/flight-direct/etc/modulerc/modulespath
fi
