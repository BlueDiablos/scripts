echo -n "Free IPA Server Address (Ipv4): "
read -r freeIpaIpv4

echo -n "Free IPA Server FQDN: "
read -r freeIpaServer

echo -n "Hosts IP Address: "
read -r hostIp

echo -n "Hosts domain name: "
read -r hostDomain

echo -n "Hosts name without the domain (IE forgo *.example.com: "
read -r hostName

echo -n "Free IPA domain: "
read -r freeIpaDomain

echo -n "Free IPA realm: "
read -r realmName

echo -n "Installing freeipa-client"

sudo apt install freeipa-client -y oddjob-mkhomedir -y

echo "$freeIpaIpv4 $freeIpaServer ipa" | sudo tee -a /etc/hosts
echo "$hostIp $hostDomain $hostName" | sudo tee -a /etc/hosts

sudo ipa-client-install --hostname="$hostDomain" --mkhomedir --server="$freeIpaServer" --domain "$freeIpaDomain" --realm "$realmName"

echo "required pam_mkhomedir.so umask=0022 skel=/etc/skel" | sudo tee -a /usr/share/pam-configs/mkhomedir

echo "Successfully configured..updating and restarting PAM"

sudo pam-auth-update
