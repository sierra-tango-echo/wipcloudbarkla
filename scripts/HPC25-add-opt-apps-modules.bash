if ! grep -q /opt/apps/alces/etc/modules /opt/flight-direct/etc/modulerc/modulespath; then
  echo >> /opt/flight-direct/etc/modulerc/modulespath
  echo "/opt/apps/alces/etc/modules" >> /opt/flight-direct/etc/modulerc/modulespath
fi

if [ ! -d /opt/apps/alces/etc/modules ]; then
  mkdir -p /opt/apps/alces/etc/modules
  cp /opt/flight-direct/etc/modules/null /opt/apps/alces/etc/modules
fi

if ! grep -q /opt/apps/etc/modules /opt/flight-direct/etc/modulerc/modulespath; then
  echo >> /opt/flight-direct/etc/modulerc/modulespath
  echo "/opt/apps/etc/modules" >> /opt/flight-direct/etc/modulerc/modulespath
fi

if [ ! -d /opt/apps/etc/modules ]; then
  mkdir -p /opt/apps/etc/modules
  cp /opt/flight-direct/etc/modules/null /opt/apps/etc/modules
fi
