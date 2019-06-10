if [ ! -d /opt/flight-direct ]; then
  curl -L https://raw.githubusercontent.com/alces-software/flight-direct/master/scripts/bootstrap.sh | bash -s 2.1.4
  source /etc/profile
  if hostname -s | grep -q login; then
    ROLE=login
  else
    ROLE=compute
  fi
  flight config set role=$ROLE clustername=cloudbarkla
  flight forge install flight-$ROLE
  if [ "$ROLE" == "login" ]; then
    flight session enable base/gnome
  fi
  sed -i 's/.*cw_GRIDWARE_allow_users=.*/cw_GRIDWARE_allow_users=false/g' /opt/flight-direct/etc/gridware.rc
  flight storage enable base/s3
fi

if [ -f /opt/flight-direct/etc/motd.d/00-tips-00-clusterware-docs.txt ]; then
  rm -rf /opt/flight-direct/etc/motd.d
  mkdir /opt/flight-direct/etc/motd.d
  cat <<EOF > /opt/flight-direct/etc/motd.d/00-header.txt
TIPS:

EOF
  echo -ne "\n" > /opt/flight-direct/etc/motd.d/99-footer.txt
  cat <<EOF > /opt/flight-direct/etc/motd.d/00-tips-05-gridware.txt
################################################################################
##
## Alces Clusterware - Clusterware MOTD banner
## Copyright (c) 2019-present Alces Flight Ltd
##
################################################################################
'module avail'            - show available application environments
'module add <modulename>' - add a module to your current environment
EOF
fi

if [ -d /opt/flight-direct ]; then
    cd /opt/flight-direct
    patch -r - -N -p1 <<'EOF'
diff --git a/bin/alces b/bin/alces
index e82908a..a142d00 100755
--- a/bin/alces
+++ b/bin/alces
@@ -1,2 +1,3 @@
 #!/bin/bash -l
-flight "$@"
+source /opt/flight-direct/etc/runtime.sh
+/opt/flight-direct/bin/flight "$@"
diff --git a/etc/clusterware.rc b/etc/clusterware.rc
index d786777..e8cdcab 100644
--- a/etc/clusterware.rc
+++ b/etc/clusterware.rc
@@ -1,4 +1,4 @@
 #
 # This config is only included becauses gridware expects it to exist
 #
-
+cw_VERSION=2.0.0
EOF
  patch -r - -N -p0 <<'EOF'
--- etc/modules-alces.tcl.orig	2017-11-30 13:10:31.979589216 +0000
+++ etc/modules-alces.tcl	2019-06-05 13:13:35.807050308 +0100
@@ -4,6 +4,7 @@
 ## Copyright (c) 2008-2015 Alces Software Ltd
 ##
 ################################################################################
+
 namespace eval ::alces {
     namespace ensemble create
     namespace export once getenv try-deeper try-next pretty
@@ -143,7 +144,9 @@
 	variable ok
 	set original_branch [alces getenv cw_INTERNAL_BRANCH]
 	set original_trunk [alces getenv cw_INTERNAL_TRUNK]
-	processing
+	if { [processing] == 1 } {
+	    return
+	}
 	if { [info exists ::env(cw_INTERNAL_PROCESSING)] == 0 } {
 	    set ::env(cw_INTERNAL_PROCESSING) true
 	    set original_processing 1
@@ -222,10 +225,10 @@
         }
         if { [is-loaded ${m}] == 1 } {
             puts stderr " ... $skipped (already loaded)"
-            break
+	    return 1
         } elseif { [alt-is-loaded ${m}] == 1 } {
             puts stderr " ... $alt (have alternative: [alces pretty $::env(cw_INTERNAL_ALT)])"
-            break
+	    return 1
         } else {
             puts stderr ""
         }
EOF
  if [ -f /opt/flight-direct/embedded/bin/pkg-config ]; then
    mv /opt/flight-direct/embedded/bin/pkg-config /opt/flight-direct/embedded/bin/pkg-config.not
  fi
fi

