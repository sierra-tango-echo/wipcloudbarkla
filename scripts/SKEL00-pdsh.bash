yum -y install pdsh-mod-genders pdsh

cat << EOF > /etc/genders
head[1,2] headnodes,service,master,all
mds[1,2] mds,lustre,storage,slave,service,all
oss[1,2] oss,lustre,storage,slave,service,all
data[1,2] data,slave,service,all
db05stor1 stor,slave,service,all


login[1,2] login,slave,user,all
db04gpu[01-06],db05gpu[01-07]    gpu,slave,user,all
d8mem[1-2]      d8,compute,slave,user,all,mem

d8s0b[1-4],d8s1b[1-4],d8s2b[1-4],d8s3b[1-4],d8s4b[1-4],d8s5b[1-4],d8s6b[1-4],d8s7b[1-4],d8s8b[1-4]   d8,compute,slave,user,all
d10s0b[1-4],d10s1b[1-4],d10s2b[1-4],d10s3b[1-4],d10s4b[1-4],d10s5b[1-4],d10s6b[1-4],d10s7b[1-4],d10s8b[1-4],d10s9b[1-4],d10s10b[1-4]    d10,compute,slave,user,all
d11s0b[1-4],d11s1b[1-4],d11s2b[1-4],d11s3b[1-4],d11s4b[1-4],d11s5b[1-4],d11s6b[1-4],d11s7b[1-4],d11s8b[1-4],d11s9b[1-4],d11s10b[1-4]    d11,compute,slave,user,all
d12s0b[1-4],d12s1b[1-4],d12s2b[1-4],d12s3b[1-4],d12s4b[1-4],d12s5b[1-4],d12s6b[1-4],d12s7b[1-4],d12s8b[1-4],d12s9b[1-4],d12s10b[1-4]    d12,compute,slave,user,all
EOF
