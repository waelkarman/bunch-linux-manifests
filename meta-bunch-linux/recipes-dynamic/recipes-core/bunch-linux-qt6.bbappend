SUMMARY = "bunch-linux-qt6 is an image that is suitable for Qt6 development"

inherit populate_sdk_qt6
IMAGE_INSTALL += " packagegroup-qt6-essentials packagegroup-qt6-addons"
