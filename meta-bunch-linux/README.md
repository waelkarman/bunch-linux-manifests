[IN DEVELOPMENT]<br>
Bunch linux is a project created to fully understand the foundations of systems and applications starting from the lowest possible level. The idea is to create a fully working alternative to Raspbian OS. <br>
<br>
Please refer to the [official webpage](https://waelkarman.github.io/bunch-linux-manifests/) for building.

# bunch-linux-metalayer
## Buildable images

- bunch-linux-demo
- bunch-linux-minimal
- bunch-linux-qt5
- bunch-linux-qt6

## System Update OTA
set the right date to be able to sign the bundle.
> date -s 'yyy/mm/gg'

## WiFi 
Notes:
connection is working but should be set up manually:<br>
- list interfaces:<br>
> ip link show<br>
- enable wlan interface:<br>
> ip link set wlan0 up<br>

populate /etc/wpa_supplicant.conf like:

> ctrl_interface=/var/run/wpa_supplicant<br>
> ctrl_interface_group=0<br>
> update_config=1<br>
> 
> network={<br>
>         ssid="insert here your SSID"<br>
>         scan_ssid=1<br>
>         key_mgmt=WPA-PSK<br>
>         psk="insert here your password"<br>
> }<br>

> wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant.conf<br>
> udhcpc -i wlan0<br>

# Kernel Modules

To test kernel modules quickly build the basic image

> kas build ./kas/bunch-linux-basic.yml --update --force-checkout

Install QEMU :

> sudo apt install qemu-system-x86

and run tha compiled image within qemu :

> qemu-system-x86_64 -drive file=build/tmp/deploy/images/qemux86-64/bunch-linux-basic-qemux86-64.rootfs.wic,format=raw -enable-kvm -cpu host -m 4096

The installed module will be located at:

> /lib/modules/kernel-version/updates/

then use insmod to load the desired module.
