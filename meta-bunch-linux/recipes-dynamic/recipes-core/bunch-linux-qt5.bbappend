SUMMARY = "bunch-linux-qt5 is an image that is suitable for Qt5 development"

inherit populate_sdk_qt5
IMAGE_INSTALL += " packagegroup-qt5-toolchain-target packagegroup-qt5-qtcreator-debug"
