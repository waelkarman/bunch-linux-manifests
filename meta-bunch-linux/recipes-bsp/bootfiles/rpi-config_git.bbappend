do_deploy:append() {
    if [ "${RASPBERRYPI_BUZZER}" = "1" ]; then
        echo "# Enable Buzzer" >> $CONFIG
        echo "dtoverlay=bcm2711-rpi-4-b-buzzer" >> $CONFIG
    fi
}