do_deploy:append() {
    if [ "${RASPBERRYPI_ACTIVE_BUZZER}" = "1" ]; then
        echo "# Enable Active Buzzer" >> $CONFIG
        echo "dtoverlay=bcm2711-rpi-4-b-active-buzzer" >> $CONFIG
    fi

    if [ "${RASPBERRYPI_PASSIVE_BUZZER}" = "1" ]; then
        echo "# Enable Passive Buzzer" >> $CONFIG
        echo "dtoverlay=bcm2711-rpi-4-b-passive-buzzer" >> $CONFIG
    fi
    
    if [ "${RASPBERRYPI_PCA9685}" = "1" ]; then
        echo "# Enable PCA9685" >> $CONFIG
        echo "dtoverlay=bcm2711-rpi-4-b-PCA9685" >> $CONFIG
    fi
}
