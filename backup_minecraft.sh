#!/bin/bash

echo "Stopping Minecraft Server...";

pkill java;

sleep 25;

rsync -azP --delete /home/naildownx/minecraft /mnt/SALVARE/rsyncBackup/

sleep 180;

cd /home/naildownx/minecraft && /bin/bash /home/naildownx/bin/minecraft-server
