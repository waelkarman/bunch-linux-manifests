do_install:append() {
    echo "bunch-linux-dev" > ${D}${sysconfdir}/hostname
    
    sed -i 's/127\.0\.1\.1.*/127.0.1.1 bunch-linux-dev/' ${D}${sysconfdir}/hosts
    
    if ! grep -q "127.0.1.1 bunch-linux-dev" ${D}${sysconfdir}/hosts; then
        echo "127.0.1.1 bunch-linux-dev" >> ${D}${sysconfdir}/hosts
    fi
}