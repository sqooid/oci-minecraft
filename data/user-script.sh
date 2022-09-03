#!/bin/bash
set -x

# Connecting to volume
VOLUME_IQN="${volume_iqn}"
VOLUME_ADDRESS="${volume_ip}:${volume_port}"

sudo iscsiadm -m node -o new -T VOLUME_IQN -p VOLUME_ADDRESS
sudo iscsiadm -m node -T VOLUME_IQN -o update -n node.startup -v automatic
sudo iscsiadm -m node -T VOLUME_IQN -p VOLUME_ADDRESS -l

# Formatting if not formatted yet
if [ -z "$(lsblk /dev/sdb -no fstype | xargs)" ]; then
	sudo mkfs -t ext4 /dev/sdb
else
	echo "Already formatted"
fi

# Mounting
sudo mkdir /minecraft
sudo chown ubuntu:ubuntu /minecraft
UUID="$(blkid | grep /dev/sdb | gawk 'match($0, /UUID="([a-z0-9\-]+)"/, a) {print a[1]}')"
sudo bash -c "echo 'UUID=\"$UUID\" /minecraft ext4 defaults,noatime,_netdev 0 2' >> /etc/fstab"
sudo mount /dev/sdb /minecraft

cd /minecraft

# Fabric
curl -s https://meta.fabricmc.net/v2/versions/loader/1.19.2/0.14.9/0.11.1/server/jar -o server.jar
chmod +x server.jar

# Mods
mkdir -p /minecraft/mods && cd /minecraft/mods
curl \
-OLs https://github.com/gnembon/fabric-carpet/releases/download/1.4.83/fabric-carpet-1.19.1-1.4.83+v220727.jar \
-Os https://mediafiles.forgecdn.net/files/3923/806/lithium-fabric-mc1.19.2-0.8.3.jar \
-Os https://mediafiles.forgecdn.net/files/3936/24/fabric-api-0.60.0%2B1.19.2.jar \
-Os https://mediafiles.forgecdn.net/files/3906/387/cloth-config-8.0.75-fabric.jar \
-Os https://mediafiles.forgecdn.net/files/3911/266/textile_backup-2.4.0-1.19.1.jar

cd /minecraft
java -jar server.jar nogui
sed -i "s/false/true/" eula.txt
echo "java -Xmx20G -jar server.jar nogui" > server-start.sh
chmod +x server-start.sh
./server-start.sh