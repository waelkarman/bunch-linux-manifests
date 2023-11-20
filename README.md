
# Welcome to Embedded Bunch Linux OS
![alt text](https://github.com/waelkarman/bunch-linux-manifests/blob/main/miscellaneous/wayland-screenshot-turtle-v0.1.png?raw=true)
Bunch Linux is a project created for learning purposes. The goal is to learn how to build your own custom version of Linux for Embedded Systems as well as the well-known goal of every developer, have fun!
The idea is to fully understand the foundations of systems and applications starting from the lowest possible level. The idea is to create a fully working alternative to Raspbian OS.

To get an overview about current and future state refer to the [CHANGELOG.md](https://github.com/waelkarman/bunch-linux-manifests/blob/main/CHANGELOG.md) .

Bunch Linux was built over the Yocto project and it's currently based on *kirkstone*. Starting from poky distro is slowly getting way more customized by adding new feature, support more sensors and hardware. The project targets to be working out of the box. The sources had been defined in a manifest and will be collected by *KAS* *project* that will download the sources and setup the directory ready to start building the system. 

## System
The system runs the version 5.15 of the linux kernel and U-Boot is used to handling the boot sequence. *systemd* has been used as the init program and primary data reading and communication services have been added to startup depending on the main target *multi-user.target*.
To view the entire system boot services, you can use the following command: <br/>
> systemctl list-units --type=service --all <br/>

# Integration 
As highlighted, the primary goal is to grasp the essential principles of applications and their interactions with the system. This involves a proactive effort to integrate various types of applications and to thoroughly understand their functioning within the system. So far, the following applications have been successfully integrated:<br/>
1. C/C++ applications<br/>
2. Python applications<br/>
3. Qt/QML applications<br/>
4. Kernel Modules<br/>

#### Integrated Services: 
- passivebuzzer-service (Python)
- gpio-read-sysfs-service (C++)
- networkchecker-service (Python)
- automounter-service \[beta\] (Shell Script)

## HMI
##### Weston
Native weston interface had been customized with some patches to create a nice HMI and *QtWayland* had been installed to allow Qt applications to be managed by the compositor. 

![alt text](https://github.com/waelkarman/bunch-linux-manifests/blob/main/miscellaneous/qtappwaylandalpha.png?raw=true)

To get *weston* manage the qt application should be set the variable *QT_QPA_PLATFORM* to wayland or just using the option *--platform wayland* launching the app.

## Audio 
ALSA + PipeWire, 
aplay and arecord [WORK IN PROGRESS: NOT TESTED] 

## IPC
##### ZeroMQ
services and applications exchanging messages through a flexible interprocess communication based on [ZeroMQ](https://zeromq.org/). This way applications written with any language could exchange rapidly information and work as a single application. The interesting aspect of ZMQ is that the message exchanging is based on network protocols that allow any node over the network to be reached even cloud applications for example. 
For the specific case, the following are the available messaging exchange models:<br/>
Request–Reply<br/>
Publish–Subscribe<br/>

In the following diagram, the communication schema of the sensors-app already installed on the system is shown.

![alt text](https://github.com/waelkarman/bunch-linux-manifests/blob/main/miscellaneous/sensorappcommunication.png?raw=true)

Similar to any advanced embedded device like an infotainment, a dashboard and so forth the *sensor-app* allows the users to check the status of the supported sensors and to control it directly from the GUI. 

The app is developed in Qt, while the services are implemented in Python and C++. The Python services rely on the pi-blaster and raspi-gpio libraries, while the C++ services utilize a custom library that directly writes to the SYS filesystem of the operating system, corresponding to the following operations:
> echo [numGPIO] \> /sys/class/gpio/export<br/>
> echo out > /sys/class/gpio/gpio[numGPIO]/direction<br/>
> echo 1 > /sys/class/gpio/gpio[numGPIO]/value<br/>

The sysfs interface for PWM was enabled but has been deprecated since Linux kernel version 4.19.

Here are examples of services utilizing interprocess communication (IPC) written in both Python and C++ that are included in the apps:<br/>
* zmq-pubblisher<br/>
* zmq-subscriber<br/>
* zmq-requester<br/>
* zmq-replier<br/>

## LOCAL & OTA System UPDATE 
For going through the development process a fundamental step is to set-up a proper update process. Rauc looks a good choice for separing applications from system and be able to update both separately without any loss of data. <br/>
![alt text](https://github.com/waelkarman/bunch-linux-manifests/blob/main/miscellaneous/update-mechanism.png?raw=true)

STATUS: Configuration and Boot script IN PROGRESS

## Wifi & Bluetooth 
Wifi and Bluetooth setting-app still not available but wifi connection is working setting it up manually:<br>
- list interfaces:<br>
> ip link show<br>
- enable wlan0 interface:<br>
> ip link set wlan0 up<br>

add configuration to /etc/wpa_supplicant.conf :

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

Activate connection:<br>

> wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant.conf<br>
> udhcpc -i wlan0<br>


## How to build
Working tested configuration and requirements:<br/>
Host machine:<br/> 

> Ubuntu 20.04.6 LTS (Focal Fossa)<br>
> Debian 12 <br>

Target:<br/>

> RaspberryPi 4 Model B<br/>

Connected GPIO:<br>
> 17 for Passive Buzzer signal<br/>
> 18 for Button Signal<br/>

Software:<br/>

> Python 3.8.10<br/>
> kas in /usr/local/lib/python3.8/dist-packages (4.0)<br/>
> distro<2,>=1.0.0 in /usr/lib/python3/dist-packages (from kas) (1.4.0)<br/>
> kconfiglib<15,>=14.1.0 in /usr/local/lib/python3.8/dist-packages (from kas) (14.1.0)<br/>
> jsonschema<4,>=2.5.0 in /usr/local/lib/python3.8/dist-packages (from kas) (3.2.0)<br/>
> PyYAML<6,>=3.0 in /usr/lib/python3/dist-packages (from kas) (5.3.1)<br/>
> six>=1.11.0 in /usr/lib/python3/dist-packages (from jsonschema<4,>=2.5.0->kas) (1.14.0)<br/>
> pyrsistent>=0.14.0 in /usr/local/lib/python3.8/dist-packages (from jsonschema<4,>=2.5.0->kas) (0.19.3)<br/>
> setuptools in /usr/lib/python3/dist-packages (from jsonschema<4,>=2.5.0->kas) (45.2.0)<br/>
> attrs>=17.4.0 in /usr/local/lib/python3.8/dist-packages (from jsonschema<4,>=2.5.0->kas) (23.1.0)<br/>

Bunch-Linux a day will become OpenSource but for now is just an experimental system build for learning purpose. Currently to build the system a TOKEN is required. Please ask to the administrator. <br/>
The building process could arise some warning due to some features in development.
### Using KAS project
KAS 4 provide an easy way to collect the sources, setup the environment and start the build process.
Install kas :<br/>

> pip3 install kas<br/>

clone this manifest :<br/>

> git clone \<URL to this repo\><br/>
> cd  bunch-linux-manifests<br/>

replace \<token\> in the YAML file *kas/bunch-linux.yml* <br/>
Start the to build the system: <br/>

> kas build kas/bunch-linux.yml<br/>

It could take a while depending on the machine that are you using for compiling. <br/>

### Using Repo-Tool (deprecated)
*Google* *repo* *tool* is needed to collect the sources and start the build process. To setup the environment and start building the system should be sourced the *setup-environment* shell script that could be found in the source folder.  To build from sources you can init the repo to the *manifest* and synchronize the sources easily. Repo tool will download the sources and configure the environment for you.<br/> 
> repo init -u https://\<TOKEN\>@github.com/waelkarman/bunch-linux-manifests.git -m v6.3.0.xml -b master<br/>
> repo sync<br/>
 
Once the environment is properly set you should source to the *setup-environment* script and then launch the compilation of the distro using *bitbake* yocto tool.
> source setup-environment<br/>
> bitbake bunch-linux<br/>

### Deploy
The compiled image will be located into the build folder at the following path:
> /build/tmp/deploy/images/raspberrypi4-64

Getting the image it should be flashed through linux dd, bmaptool command or using third party software like *BalenaEtcher*, *Raspberry* *Imager*.
zcat
> gunzip -c \<IMAGE\>.wic.gz | dd of=/dev/sda bs=1M iflag=fullblock oflag=direct conv=fsync  status=progress && sync

> bmaptool copy \<IMAGE\>.wic.gz /dev/sda && sync
