#!/bin/sh

SYSTEM_INFO=/etc/os-release
DOWNLOADED_VERSION=/tmp/bunch-update.json
BUNCH_UPDATE_BUNDLE=/home/root/update.raucb
BUNCH_SERVER=https://waelkarman.github.io/bunch-linux-manifests

rm -f "${DOWNLOADED_VERSION}" "${BUNCH_UPDATE_BUNDLE}"

if ! curl --connect-timeout 5 --silent --fail --output "${DOWNLOADED_VERSION}" "${BUNCH_SERVER}/bunch-update.json" ; then
	echo "Failed to download: ${BUNCH_SERVER}/bunch-update.json"
	exit 0
fi

CURRENT_SYSTEM_VERSION=$(cat ${SYSTEM_INFO} | grep VERSION_ID | sed "s/VERSION_ID=//g" | sed "s/-.*$//g" )
DOWNLOADED_SYSTEM_VERSION=$(cat ${DOWNLOADED_VERSION} | jq .version | sed "s/\"//g" | sed "s/-.*$//g" )
NIGHTLY_CODE=$(cat ${SYSTEM_INFO} | grep VERSION_ID | sed "s/VERSION_ID=//g" | sed "s/^.*-//g" )
DOWNLOADED_SYSTEM_VERSION_NIGHTLY=$(cat ${DOWNLOADED_VERSION} | jq .version | sed "s/\"//g" | sed "s/^.*-//g" )

if [ "$CURRENT_SYSTEM_VERSION" = "$DOWNLOADED_SYSTEM_VERSION" ] ; then
	if [ "$NIGHTLY_CODE" = "$DOWNLOADED_SYSTEM_VERSION_NIGHTLY" ] ; then
		echo "System up to date."
		exit 0
	fi
fi
echo "Version ${DOWNLOADED_SYSTEM_VERSION} available."

DOWNLOADED_SYSTEM_BUNDLE=$(cat ${DOWNLOADED_VERSION} | jq .url | sed "s/\"//g")

if ! wget --output-document=${BUNCH_UPDATE_BUNDLE}  ${DOWNLOADED_SYSTEM_BUNDLE} ; then
	echo "Failed to download: ${DOWNLOADED_SYSTEM_BUNDLE}"
	exit 0
fi

printf "Update system version ${CURRENT_SYSTEM_VERSION} -> ${DOWNLOADED_SYSTEM_VERSION} \n"
printf "Start updating..\n"
if rauc install ${BUNCH_UPDATE_BUNDLE} ; then
	printf "System Updated\n"
	rm -f ${BUNCH_UPDATE_BUNDLE}
	reboot
else
	printf "Update Failed\n"
	rm -f ${BUNCH_UPDATE_BUNDLE}
fi