#!/bin/bash

#= Script checks the local weather as well as the Minecraft Version

#= Variables
mcVerTxt="/home/naildownx/scripts/mc_version.txt"
mcTmpDir="/tmp/mc-version"
mcVerJson="${mcTmpDir}/version_manifest.json"
weatherTmp="${mcTmpDir}/weather.txt"
weatherURL="http://wttr.in/"
mcURL="https://launchermeta.mojang.com/mc/game/version_manifest.json"

#= Download Manifest
mkdir -p "$mcTmpDir"
curl -o "$mcVerJson" --silent "$mcURL"
curl -o "$weatherTmp" --silent "$weatherURL"
python -m json.tool "$mcVerJson" > "$mcVerJson".temp
weatherDisplay="$(sed '7q;' "$weatherTmp" | sed 's/, United States//g; s/Weather report: //g;')"
mcVersionNew="$(sed '3q;d' "$mcVerJson".temp | sed 's/release//g; s/"//g; s/://g; s/,//g; s/[\t ]//g;/^$/d')"
mcVersionOld="$(cat "$mcVerTxt")"

#= Display local weather
echo "$weatherDisplay";

#= Compare + Notify
if (( $(echo "$mcVersionNew $mcVersionOld" | awk '{print ($1 > $2)}') )); then
  { echo ""; echo -e "Minecraft Version: $mcVersionNew vs \033[31m\u2613 $mcVersionOld\e[0m"; echo ""; echo "$mcVersionNew" > "$mcVerTxt";
	printf "Subject: Minecraft %s is out!\n\nExisting Version: %s\nNew Version: %s" "$mcVersionNew" "$mcVersionOld" "$mcVersionNew" | msmtp -a default youremailaddress@domain.com; }
else
  { echo ""; echo -e "Minecraft Version: $mcVersionNew vs \e[32m\u2713 $mcVersionOld\e[0m"; echo ""; }
fi

rm -rf "$mcTmpDir"
