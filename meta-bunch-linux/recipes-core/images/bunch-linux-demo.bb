SUMMARY = "BunchLinux is an embedded OS image where to integrate any possible software"

inherit core-image
require bunch-linux-core.inc

inherit core-image
inherit populate_sdk_qt6
inherit extrausers

# To generate a valid pass: printf "%q" $(mkpasswd -m sha256crypt admin-nosexinthechurch)
PASSWD = "\$5\$YA7nDY0J\$th7S4jEgsrMeq45QCksPT6.gKk0Wqu3kO9xCgt7Yj43"

EXTRA_USERS_PARAMS = " \
    usermod -p '${PASSWD}' weston; \
"

IMAGE_FEATURES += " weston"

IMAGE_INSTALL += " weston-xwayland xwayland connman connman-client opengl-es-cts"
IMAGE_INSTALL += " hello-module"
IMAGE_INSTALL += " wlan-enabler systemdservices passivebuzzer-service button-service networkchecker-service nautilus icon-weston"
IMAGE_INSTALL += " bunch-update neatvnc"
IMAGE_INSTALL += " packagegroup-qt6-essentials packagegroup-qt6-addons sensors-app burger-app open-pipe-media-player gtk+3 mesa"
IMAGE_INSTALL += " gstreamer1.0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly ffmpeg"

do_deploy_to_rasp() {
    # Codice personalizzato da eseguire alla fine della creazione del pacchetto
    # L'output è visibile al path: build/tmp/work/bunch_raspberrypi4_64-poky-linux/bunch-linux/1.0-r0/temp/log.do_deploy_to_rasp
    echo "Custom deploy task."
    echo "- current path: $(pwd)"
    #scp $(pwd)/tmp/deploy/images/bunch-raspberrypi4-64/bunch-linux-bundle-bunch-raspberrypi4-64.raucb root@192.168.1.28:~/
    #dd if=$(pwd)/tmp/deploy/images/bunch-raspberrypi4-64/bunch-linux-bundle-bunch-raspberrypi4-64.raucb of=/dev/sda bs=4M
}

addtask deploy_to_rasp after do_image_complete
