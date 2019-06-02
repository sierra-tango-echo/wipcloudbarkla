yum -y install epel-release
yum -y install openvpn easy-rsa
cp -pav /usr/share/easy-rsa/3.0.3 /etc/openvpn/easyrsa
cd /etc/openvpn/easyrsa

cat<< 'EOF' > /etc/openvpn/easyrsa/vars
if [ -z "$EASYRSA_CALLER" ]; then
    echo "You appear to be sourcing an Easy-RSA 'vars' file." >&2
    echo "This is no longer necessary and is disallowed. See the section called" >&2
    echo "'How to use this file' near the top comments for more details." >&2
    return 1
fi

set_var EASYRSA        "$PWD"
set_var EASYRSA_OPENSSL        "openssl"
set_var EASYRSA_PKI            "$EASYRSA/pki"
set_var EASYRSA_DN     "org"

set_var EASYRSA_REQ_COUNTRY    "UK"
set_var EASYRSA_REQ_PROVINCE   "Oxfordshire"
set_var EASYRSA_REQ_CITY       "Oxford"
set_var EASYRSA_REQ_ORG        "Alces Flight Ltd"
set_var EASYRSA_REQ_EMAIL      "ssl@alces-flight.com"
set_var EASYRSA_REQ_OU         "Infrastructure"
set_var EASYRSA_KEY_SIZE       2048

set_var EASYRSA_ALGO           rsa

set_var EASYRSA_CA_EXPIRE      3650
set_var EASYRSA_CERT_EXPIRE    3650
set_var EASYRSA_CRL_DAYS       180

set_var EASYRSA_TEMP_FILE      "$EASYRSA_PKI/extensions.temp"

set_var EASYRSA_BATCH 		"true"
EOF

./easyrsa init-pki  
./easyrsa --req-cn=cluster0 build-ca nopass 

./easyrsa --req-cn=cluster0 gen-req cluster0 nopass
./easyrsa sign-req server cluster0

./easyrsa --req-cn=clusterX gen-req clusterX nopass
./easyrsa sign-req client clusterX

./easyrsa gen-dh
./easyrsa gen-crl
openvpn --genkey --secret ta.key

cat << EOF > /etc/openvpn/flightconnector.conf
mode server
tls-server
port 2005
proto tcp-server
dev tun0


ca /etc/openvpn/easyrsa/pki/ca.crt
cert /etc/openvpn/easyrsa/pki/issued/cluster0.crt
key /etc/openvpn/easyrsa/pki/private/cluster0.key
dh /etc/openvpn/easyrsa/pki/dh.pem
crl-verify /etc/openvpn/easyrsa/pki/crl.pem

client-config-dir ccd-clusters
ccd-exclusive
client-to-client

ifconfig 10.78.110.1 255.255.255.0
topology subnet
route 10.10.0.0 255.255.0.0 10.78.110.2

keepalive 10 120
comp-lzo adaptive
tls-auth /etc/openvpn/easyrsa/ta.key 0
cipher AES-256-CBC
auth SHA512
tls-version-min 1.2
tls-cipher TLS-DHE-RSA-WITH-AES-256-GCM-SHA384
persist-key
persist-tun

status openvpn-status.log
log         /var/log/openvpn.log
log-append  /var/log/openvpn.log
verb 3
EOF

mkdir /etc/openvpn/ccd-clusters
cat << EOF > /etc/openvpn/ccd-clusters/clusterX
ifconfig-push 10.78.110.2 255.255.255.0
push "route 10.210.0.0 255.255.0.0 10.78.110.1"
iroute 10.10.0.0 255.255.0.0
EOF

cat << '_EOF_' >> /etc/openvpn/buildinstaller.sh
CLUSTER=$1
IP=`curl --silent http://ipecho.net/plain`
CA=`cat /etc/openvpn/easyrsa/pki/ca.crt`
CRT=`cat /etc/openvpn/easyrsa/pki/issued/$CLUSTER.crt`
KEY=`cat /etc/openvpn/easyrsa/pki/private/$CLUSTER.key`
TA=`cat /etc/openvpn/easyrsa/ta.key`

cat << EOF > /root/install_$CLUSTER.run
cat << EOD > /etc/openvpn/flightconnector.conf
client
dev tun
proto tcp
remote $IP 2005
remote-cert-tls server
resolv-retry infinite
nobind
persist-key
persist-tun
<ca>
$CA
</ca>
<cert>
$CRT
</cert>
<key>
$KEY
</key>
comp-lzo adaptive
verb 0
cipher AES-256-CBC
auth SHA512
tls-version-min 1.2
tls-client
tls-cipher TLS-DHE-RSA-WITH-AES-256-GCM-SHA384
key-direction 1
<tls-auth>
$TA
</tls-auth>
topology subnet
EOD
EOF
_EOF_

bash /etc/openvpn/buildinstaller.sh clusterX

systemctl enable openvpn@flightconnector
systemctl start openvpn@flightconnector

firewall-cmd --new-zone cluster0 --permanent
firewall-cmd --add-interface tun0 --zone cluster0 --permanent
firewall-cmd --add-interface tun0 --zone cluster0
firewall-cmd --add-port 2005/tcp --zone external --permanent

firewall-cmd --set-target=ACCEPT --zone cluster0 --permanent

