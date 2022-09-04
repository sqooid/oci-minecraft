#!/bin/bash
set -x

cd /minecraft
mkdir -p server-base && cd server-base

# Fabric
curl -s https://meta.fabricmc.net/v2/versions/loader/1.19.2/0.14.9/0.11.1/server/jar -o server.jar
chmod +x server.jar

# Mods
mkdir -p mods && cd mods
curl \
-sOL https://github.com/gnembon/fabric-carpet/releases/download/1.4.83/fabric-carpet-1.19.1-1.4.83+v220727.jar \
-sO https://mediafiles.forgecdn.net/files/3923/806/lithium-fabric-mc1.19.2-0.8.3.jar \
-sO https://mediafiles.forgecdn.net/files/3936/24/fabric-api-0.60.0%2B1.19.2.jar \
-sO https://mediafiles.forgecdn.net/files/3906/387/cloth-config-8.0.75-fabric.jar \
-sO https://mediafiles.forgecdn.net/files/3911/266/textile_backup-2.4.0-1.19.1.jar

cd ..
java -jar server.jar nogui
sed -i "s/false/true/" eula.txt
echo "screen -dmS minecraft bash -c 'java -Xmx20G -jar server.jar nogui | tee output.log'" > server-start.sh
chmod +x server-start.sh