#!/bin/bash
IP=($(dig +short myip.opendns.com @resolver1.opendns.com))
USERNAME=$(< /dev/urandom tr -dc 'A-Za-z0-9' | head -c5)
PASS=$(< /dev/urandom tr -dc 'A-Za-z0-9' | head -c14)
wget --no-check-certificate 'https://github.com/z3APA3A/3proxy/archive/0.8.11.tar.gz'
tar xzf 0.8.11.tar.gz
cd 3proxy-0.8.11
make -f Makefile.Linux
cd src
mkdir /etc/3proxy/
mv 3proxy /etc/3proxy/
cd /etc/3proxy/
wget --no-check-certificate 'https://github.com/barankilic/3proxy/raw/master/3proxy.cfg'
chmod 600 /etc/3proxy/3proxy.cfg
echo "$USERNAME:CL:$PASS" > /etc/3proxy/.proxyauth
chmod 600 /etc/3proxy/.proxyauth
chmod 777 /etc/3proxy/3proxy
cd /etc/init.d/
wget --no-check-certificate 'https://raw.github.com/barankilic/3proxy/master/3proxyinit'
chmod  +x /etc/init.d/3proxyinit
MYLINE=`grep -n COMMIT /etc/sysconfig/iptables | tail -1 | awk -F\: '{ print $1 }'`
sed -i -e "${MYLINE}i-A OS_FIREWALL_ALLOW -p tcp -m state --state NEW -m tcp --dport 3128 -j ACCEPT" /etc/sysconfig/iptables
service iptables stop
chkconfig --add 3proxyinit
chkconfig 3proxyinit on
service 3proxyinit start
echo "proxy/tcpsocks5"
echo "server: $IP"
echo "port: 3128"
echo "username: $USERNAME"
echo "pass: $PASS"
echo ""
