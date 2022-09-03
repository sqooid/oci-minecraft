#!/bin/bash
set -x

curl -s https://meta.fabricmc.net/v2/versions/loader/1.19.2/0.14.9/0.11.1/server/jar -o server.jar
chmod +x server.jar

java -jar server.jar nogui
sed -i "s/false/true/" eula.txt
java -Xmx20G -jar server.jar nogui