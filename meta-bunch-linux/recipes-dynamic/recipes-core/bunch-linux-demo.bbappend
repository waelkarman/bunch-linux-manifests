SUMMARY = "BunchLinuxDemo is a demo to demonstrate the possible use cases of the system"

inherit populate_sdk_qt6
inherit extrausers

# To generate a valid pass: printf "%q" $(mkpasswd -m sha256crypt admin-nosexinthechurch)
PASSWD = "\$5\$YA7nDY0J\$th7S4jEgsrMeq45QCksPT6.gKk0Wqu3kO9xCgt7Yj43"

EXTRA_USERS_PARAMS = " \
    usermod -p '${PASSWD}' weston; \
"

IMAGE_FEATURES += " weston"

IMAGE_INSTALL += " weston-xwayland xwayland opengl-es-cts"
IMAGE_INSTALL += " hello-module"
IMAGE_INSTALL += " systemdservices passivebuzzer-service button-service networkchecker-service nautilus icon-weston"
IMAGE_INSTALL += " bunch-update neatvnc"
IMAGE_INSTALL += " packagegroup-qt6-essentials packagegroup-qt6-addons sensors-app burger-app open-pipe-media-player gtk+3 mesa"
IMAGE_INSTALL += " gstreamer1.0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly ffmpeg"