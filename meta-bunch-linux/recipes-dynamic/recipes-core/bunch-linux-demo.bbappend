SUMMARY = "BunchLinuxDemo is a demo to demonstrate the possible use cases of the system"

inherit populate_sdk_qt6
inherit extrausers

# To generate a valid pass: printf "%q" $(mkpasswd -m sha256crypt admin-nosexinthechurch)
PASSWD = "\$5\$YA7nDY0J\$th7S4jEgsrMeq45QCksPT6.gKk0Wqu3kO9xCgt7Yj43"

EXTRA_USERS_PARAMS = " \
    usermod -p '${PASSWD}' weston; \
"

IMAGE_INSTALL += " bunch-update neatvnc"
IMAGE_INSTALL += " sensors-app burger-app open-pipe-media-player custom-kernel-modules nautilus"
IMAGE_INSTALL += " systemdservices passivebuzzer-service button-service networkchecker-service icon-weston"
IMAGE_INSTALL += " packagegroup-qt6-essentials packagegroup-qt6-addons"
