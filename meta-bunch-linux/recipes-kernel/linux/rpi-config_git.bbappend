
do_deploy:append() {
    CONFIG=${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt

    if [ "${HDMI_ENABLE_4KP60}" = "1" ]; then
        echo "hdmi_enable_4kp60=${HDMI_ENABLE_4KP60}" >>$CONFIG
    fi

}
