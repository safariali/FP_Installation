#!/bin/sh
#
if [ "$#" -lt "2" ]; then
  echo "usage: `basename $0` <d or r or D or R for debug/release  284 for RELEASE_OR_DEBUG [example: ./fp_install.sh d 284]> "
  exit 1
fi

RELEASE_OR_DEBUG=${1}
BUILD_NUMBER=${2}
clear >$(tty)

Chrome_Version=`/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --version`

echo "Installing FP play_32_0_${RELEASE_OR_DEBUG}0_${BUILD_NUMBER} on ${Chrome_Version}"

if [ "${RELEASE_OR_DEBUG}" = "d" -o "${RELEASE_OR_DEBUG}" = "D" ]; then
    curl -u safari ftp://sjstore.corp.adobe.com/builds03/flashruntime/production_builds/flashruntime/32.0-evans/play_32_0_d0_${BUILD_NUMBER}/pepper_binaries/osx10-64/release/raw_build/PepperFlashPlayer.dmg -o ${RELEASE_OR_DEBUG}-${BUILD_NUMBER}.dmg
elif [ "${RELEASE_OR_DEBUG}" = "r" -o "${RELEASE_OR_DEBUG}" = "R" ]; then
    curl -u safari ftp://sjstore.corp.adobe.com/builds03/flashruntime/production_builds/flashruntime/32.0-evans/play_32_0_r0_${BUILD_NUMBER}/pepper_binaries/osx10-64/release/raw_build/PepperFlashPlayer.dmg -o ${RELEASE_OR_DEBUG}-${BUILD_NUMBER}.dmg
else
    echo "usage: `basename $0` <d or r or D or R for debug/release  284 for RELEASE_OR_DEBUG [example: ./fp_install.sh d 284]> "
    exit 1
fi

sleep 2

if [[ ! -e  ${RELEASE_OR_DEBUG}-${BUILD_NUMBER}.dmg ]]; then
    echo "play_32_0_${RELEASE_OR_DEBUG}0_${BUILD_NUMBER} is not built yet or it is not a valid build"
    echo "File did not download. Aborting...."
    exit 1
else
    pkill -a -l "Google Chrome" 2 >/dev/null
fi

[ -e /Volumes/PepperFlash* ] &&  hdiutil unmount /Volumes/PepperFlash* > /dev/null

open ${RELEASE_OR_DEBUG}-${BUILD_NUMBER}.dmg

sleep 2

## Change 32.0.0.279 to location of your FP folder
cd ~/Library/Application\ Support/Google/Chrome/PepperFlash/32.0.0.284/
sleep 1

rm -rf PepperFlashPlayer.plugin

sleep 1

cp -Rf /Volumes/PepperFlashPlayer/PepperFlashPlayer.plugin .

sleep 1
open -a "Google Chrome" http://fpqa.macromedia.com/version/FlashVersion.html
echo "*******************************************************************"
echo "* FP play_32_0_${RELEASE_OR_DEBUG}0_${BUILD_NUMBER} is installed on ${Chrome_Version} *"
echo "*******************************************************************"
sleep 1
[ -e /Volumes/PepperFlash* ] &&  hdiutil unmount /Volumes/PepperFlash* > /dev/null
