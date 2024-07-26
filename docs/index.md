# Welcome to Open Bunch Linux OS ~ Camel (v0.003 - not released) 
<img src="miscellaneous/camel-desk.png">

Bunch Linux is a project created to fully understand the foundations of systems and applications starting from the lowest possible level. The idea is to create a fully working alternative to Raspbian OS. The goal is to learn as much as possible and of course, have fun!

To get an overview about current and future state refer to the [CHANGELOG.md](https://github.com/waelkarman/bunch-linux-manifests/blob/main/CHANGELOG.md) .

Bunch Linux is slowly getting way more customized by adding new features, install new apps and support more sensors. The project targets to be working out of the box. The sources had been defined in the bunch-linux.yml manifest and will be collected by *KAS* *tool* that will download what is needed and start the building process. 

## System

The system runs the 6.6.y version of the linux kernel ([current-kernel-configuration](https://github.com/waelkarman/bunch-linux-boot-sequence/blob/main/dot-config)) and U-Boot is used to handle the boot sequence. *Systemd* is raising the userspace up and all the startup services are depending on the *multi-user.target*.

A view of the entire system services could be seen with the following command: <br/>
> systemctl list-units --type=service --all <br/>

System configuration and boot sequence deeply documented at:<br>

- [bunch-linux-boot-sequence](https://github.com/waelkarman/bunch-linux-boot-sequence) (dts, Kconfig)

## Topics 
As highlighted, the primary goal is to grasp the essential principles of applications, their domain and their interaction with the system. This involves a proactive effort to integration of various types of applications and to thoroughly understand their functioning within the system.<br>
The distro comprises the following topic:

- Linux kernel 6.6.y
- Yocto ~ Scarthgap
- C
- C++/17
- Qt6/QML
- Python3
- Cmake
- SQLite3
- Bash scripts
- GStreamer
- GTK+3
- ZeroMQ
- POSIX thread
- Kernel drivers
- Rauc Update

## Desktop environment
The system combines several other repos such as:

- [burger-app](https://github.com/waelkarman/burger-shop) (C++\17, Qt6/QML, SQLite3)
- [sensors-app](https://github.com/waelkarman/sensors-app) (C++\17, Qt6/QML)
- [open-pipe-media-player](https://github.com/waelkarman/open-pipe-media-player) (C, GStreamer, GTK+3) 
- [passivebuzzer-service](https://github.com/waelkarman/passivebuzzer-service) (Python3)
- [button-service](https://github.com/waelkarman/button-service) (C++/17)
- [networkchecker-service](https://github.com/waelkarman/networkchecker-service) (Python3)
- [auto-update-service](https://github.com/waelkarman/bunch-linux-manifests/blob/main/meta-bunch-linux%2Frecipes-core%2Fbunch-update%2Fbunch-update%2Fbunch-update.sh) (Bash Script)
- [custom-kernel-modules](https://github.com/waelkarman/kernel-modules) (C)

Services and applications are exchanging messages through a flexible and low latency interprocess communication mechanism based on [ZeroMQ](https://zeromq.org/). This way applications written with any language could exchange rapidly information and work as a single application. The interesting aspect of ZMQ is that the message exchanging mechanism is based on network protocols and that allows to any node over the network to be reached even nodes not defined on the localhost itself like cloud applications for example. <br>

The following are messages exchanging models that had been tested into the system:<br/>
- Request – Reply<br/>
- Publish – Subscribe<br/>

In the following diagram the summary of the communication layout implemented into the sensors-app is shown.

<img src="miscellaneous/sensorappipc.png" width="400" height="300">

Wiring:<br>
> GPIO[17] for Passive Buzzer signal<br/>
> GPIO[18] for Button Signal<br/>

The *sensor-app* has a grid and each supported sensor have a spot in the grid. The sensor-app allows the user to check the status of the supported sensors and control them directly from the UI. For example connecting a button as aforementioned, and pressing it, is possible to read on the sensors-app the state of the button as Pressed/Released furthermore touching on the sensor-app the spot reserved to the passive buzzer the buzzer will ring.

The sensors-app is written in Qt6/QML. The services are implemented in Python3 and C++. The services written in Python3 rely on the pi-blaster and raspi-gpio libraries to interact with the sensors while the services written in C++ utilize a custom library that directly interact with the sys-fs to control the GPIOs and mainly performs the following operations:
> echo [numGPIO] \> /sys/class/gpio/export<br/>
> echo out > /sys/class/gpio/gpio[numGPIO]/direction<br/>
> echo 1 > /sys/class/gpio/gpio[numGPIO]/value<br/>

#### HMI ~ Wayland & xWayland
The HMI is based on the native weston interface with some customization. To support app built for X Windows System, xwayland has been installed allowing X11 applications (like Nautilus) to work within the Wayland protocol. Xwayland acts like a wayland node and implements an X11 server that works as a proxy. Furthermore *QtWayland* is installed to allow Qt6 applications to be managed by the compositor.

<img src="miscellaneous/Gscheme.png" width="300" height="240">

#### Remote access

Bunch-Linux installs a remote access feature (based on VNC) through which it is possible to access the system from the development machine and control the system remotely. This functionality is useful when conducting tests without access to a monitor, and in conjunction with the system's Over-The-Air (OTA) update capability, it allows full remote control of the system for development purposes.

<img src="miscellaneous/remote-access-lama.png" width="400" height="240">

## LOCAL & OTA System UPDATE 
For going through the development process a fundamental step is to set-up a proper update process. A/B partitions look like a good choice for separating rootfs and be able to update the system without any loss of data. <br/>
<img src="miscellaneous/update-mechanism.png">

The system is capable of automatic self-updating via OTA (Over-The-Air). It is initialized with two valid root partitions. Upon an update occurs the system is automatically installing the update into the inactive partition and switch the boot pointer to the updated ones. This way an older version of the system is always kept installed and used as fallback option in case the update process went wrong. 
The update service is checking constantly whether an update is available and is keeping the system updated. All updates will be applied after reboot.

The update process is performed by RAUC and the entire update process is connected to the [bunch-linux-manifest](https://github.com/waelkarman/bunch-linux-manifests) repo. The [auto-update-service](https://github.com/waelkarman/bunch-linux-manifests/blob/main/meta-bunch-linux%2Frecipes-core%2Fbunch-update%2Fbunch-update%2Fbunch-update.sh) is regurarly checking the [bunch-update.json](https://github.com/waelkarman/bunch-linux-manifests/blob/main/docs/bunch-update.json) and reading it's attributes. Comparing the incoming attributes with the current ones, the service recognize whether a newer version of the system has been released. In that case, the *url* field of the downloaded json (that points to the release section of this repo) will be used to download the update bundle and subsequently update the system.


## Media
[WORK IN PROGRESS] 

## Connectivity
Wifi and Bluetooth setting-app still not available but wifi connection is working setting it up manually:<br>

modify the network credentials in /etc/wpa_supplicant.conf :

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

Restart wpa_supplicant@wlan0 service <br>

> systemctl restart wpa_supplicant@wlan0

## Installed Packets & Features

DISTRO FEATURES:

1. acl: Supporto per le liste di controllo degli accessi, che permettono una gestione più granulare dei permessi rispetto ai permessi tradizionali di UNIX.

2. alsa: Advanced Linux Sound Architecture, un'architettura per la gestione dell'audio su Linux.

3. argp: Libreria per la gestione dei parametri della riga di comando.

4. bluetooth: Supporto per la connettività Bluetooth.

5. debuginfod: Un servizio per la distribuzione di informazioni di debug.

6. ext2: Supporto per il filesystem ext2.

7. ipv4: Supporto per il protocollo Internet versione 4.

8. ipv6: Supporto per il protocollo Internet versione 6.

9. largefile: Supporto per file di grandi dimensioni (superiori a 2 GB).

10. pcmcia: Supporto per PCMCIA (Personal Computer Memory Card International Association), usato principalmente per schede di espansione nei laptop.

11. usbgadget: Supporto per i dispositivi USB in modalità gadget, permettendo al sistema di funzionare come un dispositivo USB.

12. usbhost: Supporto per i dispositivi USB in modalità host, permettendo al sistema di connettersi a dispositivi USB.

13. wifi: Supporto per la connettività Wi-Fi.

14. xattr: Attributi estesi, che permettono di memorizzare informazioni aggiuntive sui file.

15. nfs: Network File System, un protocollo per la condivisione di file su una rete.

16. zeroconf: Configurazione automatica della rete (Zero Configuration Networking).

17. pci: Supporto per l'interfaccia Peripheral Component Interconnect, usata per collegare componenti hardware.

18. 3g: Supporto per reti mobili 3G.

19. nfc: Supporto per la comunicazione a corto raggio (Near Field Communication).

20. x11: Supporto per il sistema di finestre X Window System, utilizzato per gestire le interfacce grafiche su UNIX e Linux.

21. vfat: Supporto per il filesystem VFAT, utilizzato comunemente sui dispositivi Windows.

22. seccomp: Secure Computing Mode, una funzionalità di sicurezza del kernel Linux che restringe le chiamate di sistema disponibili a un processo.

23. egl: API di interfaccia grafica per la connessione tra le API grafiche, come OpenGL e il sistema di finestre sottostante.

24. gbm: Generic Buffer Management, un'interfaccia per la gestione dei buffer grafici.

25. directfb: Direct Frame Buffer, una libreria grafica per l'accesso diretto al framebuffer.

26. kde: Supporto per l'ambiente desktop KDE.

27. largefile: Ripetizione del supporto per file di grandi dimensioni.

28. opengl: Interfaccia grafica multipiattaforma per la renderizzazione di grafica vettoriale 2D e 3D.

29. ptest: Supporto per i pacchetti di test, utilizzati per verificare la funzionalità del sistema e dei suoi componenti.

30. multiarch: Supporto per l'esecuzione di binari di più architetture sullo stesso sistema.

31. wayland: Protocollo per la gestione delle interfacce grafiche, considerato un sostituto moderno di X11.

32. vulkan: API per la grafica e il computing di nuova generazione, sviluppata da Khronos Group.

33. systemd: Sistema di init e gestione dei servizi per Linux, che fornisce un modo standardizzato per avviare, fermare e monitorare i servizi di sistema.

34. vnc: Virtual Network Computing, un sistema per il controllo remoto di computer tramite un'interfaccia grafica.

35. pam: Pluggable Authentication Modules, un meccanismo per integrare vari metodi di autenticazione nelle applicazioni.

36. rauc: Robust Auto-Update Controller, un framework per aggiornamenti software affidabili.

37. usrmerge: Iniziativa per unificare le directory `/bin`, `/sbin`, `/lib` e `/lib64` nelle loro controparti sotto `/usr`.

38. pulseaudio: Server sonoro che fornisce un controllo avanzato del suono su Linux.

39. gobject-introspection-data: Supporto per l'introspezione dei tipi di dati GObject, utilizzato per generare automaticamente binding per linguaggi diversi.

40. ldconfig: Utilità per la configurazione delle librerie dinamiche, usata per aggiornare il cache delle librerie condivise.

IMAGE FEATURES:

1. ssh-server-openssh: 
   - Descrizione: Aggiunge il server SSH OpenSSH all'immagine.
   - Funzionalità: Permette l'accesso remoto sicuro al sistema tramite il protocollo SSH (Secure Shell), che consente l'esecuzione di comandi da remoto e il trasferimento sicuro dei file.

2. tools-sdk: 
   - Descrizione: Include una serie di strumenti di sviluppo software (SDK).
   - Funzionalità: Fornisce gli strumenti necessari per lo sviluppo e la compilazione di software, come compilatori, debugger e librerie.

3. debug-tweaks: 
   - Descrizione: Aggiunge configurazioni di debug all'immagine.
   - Funzionalità: In genere include modifiche come la disabilitazione della password di root per facilitare l'accesso allo sviluppo e al debugging del sistema.

4. package-management: 
   - Descrizione: Aggiunge supporto per la gestione dei pacchetti.
   - Funzionalità: Permette l'installazione, l'aggiornamento e la rimozione dei pacchetti software utilizzando strumenti di gestione dei pacchetti come `opkg`, `rpm` o `dpkg`.

5. hwcodecs: 
   - Descrizione: Include codec hardware nell'immagine.
   - Funzionalità: Fornisce supporto per la codifica e decodifica video e audio utilizzando l'accelerazione hardware, migliorando le prestazioni per la riproduzione multimediale.

6. tools-debug: 
   - Descrizione: Include strumenti di debug aggiuntivi nell'immagine.
   - Funzionalità: Fornisce strumenti avanzati per il debugging del software, come debugger, profiler e altre utilità per diagnosticare e risolvere problemi nel codice.

IMAGE ADDITIONAL:

1. pi-bluetooth: Pacchetto di supporto Bluetooth per Raspberry Pi, include driver e strumenti necessari per la connettività Bluetooth.

2. bluez5: Stack Bluetooth per Linux che fornisce supporto per le tecnologie Bluetooth.

3. packagegroup-rpi-test: Gruppo di pacchetti di test per Raspberry Pi, include vari strumenti e librerie per testare il sistema.

4. python3-pyzmq: Binding Python per ZeroMQ, una libreria di messaggistica ad alte prestazioni.

5. python3: Interprete Python 3 e le sue librerie standard.

6. python3-pip: Gestore di pacchetti per Python, utilizzato per installare e gestire librerie Python.

7. supplicant-service: Servizio per la gestione delle connessioni di rete, di solito utilizzato con `wpa-supplicant`.

8. wpa-supplicant: Client per la gestione delle connessioni Wi-Fi protette con WPA e WPA2.

9. iw: Strumento per la configurazione e gestione delle reti wireless.

10. raspi-gpio: Utilità per la gestione dei pin GPIO (General Purpose Input/Output) su Raspberry Pi.

11. pi-blaster: Daemon che permette il controllo dei pin GPIO su Raspberry Pi utilizzando PWM (Pulse Width Modulation).

12. libgpiod-dev: Libreria per la gestione dei pin GPIO tramite la nuova interfaccia GPIO del kernel Linux.

13. rpi-gpio: Libreria Python per l'interfaccia con i pin GPIO su Raspberry Pi.

14. rpio: Libreria Python per il controllo avanzato dei pin GPIO su Raspberry Pi.

15. screen: Emulatore di terminale che permette di gestire sessioni multiple di terminale.

16. wget: Strumento da linea di comando per il download di file da web tramite HTTP, HTTPS e FTP.

17. net-tools: Collezione di strumenti di rete come `ifconfig`, `netstat`, `route`, `arp`.

18. jq: Processore JSON da linea di comando che consente di manipolare e trasformare dati JSON.

19. curl: Strumento da linea di comando per trasferire dati con URL sintattici.

20. tree: Strumento che mostra la struttura delle directory in forma di albero.

21. i2c-tools: Strumenti per la gestione e il debug dei bus I²C.

22. nano: Editor di testo semplice da linea di comando.

23. rsync: Strumento per la sincronizzazione di file e directory tra due posizioni.

24. systemd: Sistema di init e gestione dei servizi per Linux.

25. udev: Gestore dei dispositivi del kernel Linux.

26. udev-extraconf: Configurazioni aggiuntive per `udev`.

27. rauc: Framework per aggiornamenti software affidabili.

28. ntp: Network Time Protocol, strumento per la sincronizzazione dell'orologio di sistema con server di tempo su Internet.

29. v4l-utils: Strumenti per la gestione dei dispositivi video for Linux (V4L).

30. parted: Strumento per la manipolazione delle partizioni del disco.

31. util-linux: Collezione di utilità di sistema, tra cui `fdisk`, `mount`, `kill`, `more`, `logger`.

32. u-boot-fw-utils: Utilità per la gestione delle configurazioni di U-Boot, un bootloader comune su dispositivi embedded.

33. u-boot: Bootloader universale utilizzato su molti sistemi embedded.

34. base-files: Pacchetto base che include file di configurazione essenziali per il sistema.

35. weston-xwayland: Compositore Weston per Wayland con supporto XWayland per l'esecuzione delle applicazioni X11.

36. xwayland: Server X che gira sopra Wayland, permettendo di eseguire applicazioni X11 su un compositore Wayland.

37. opengl-es-cts: Test suite di conformità per OpenGL ES, utilizzata per verificare la conformità delle implementazioni OpenGL ES.

38. custom-kernel-modules: Moduli del kernel personalizzati.

39. systemdservices: Configurazioni e servizi aggiuntivi per systemd.

40. passivebuzzer-service: Servizio per controllare un buzzer passivo.

41. button-service: Servizio per la gestione di pulsanti hardware.

42. networkchecker-service: Servizio per monitorare lo stato della rete.

43. nautilus: File manager per l'ambiente desktop.

44. icon-weston: Icone per il compositore Weston.

45. bunch-update: Strumento per aggiornamenti di per Bunch Linux.

46. neatvnc: Implementazione VNC (Virtual Network Computing) pulita e semplice.

47. packagegroup-qt6-essentials: Gruppo di pacchetti essenziali per Qt6.

48. packagegroup-qt6-addons: Addon per Qt6, fornendo funzionalità aggiuntive.

49. sensors-app: Applicazione per il monitoraggio dei sensori collegati.

50. burger-app: Applicazione demo, spesso usata come esempio.

51. open-pipe-media-player: Lettore multimediale basato su pipe aperte.

52. gtk+3: Libreria grafica per la creazione di interfacce utente, utilizzata principalmente nel desktop environment.

53. mesa: Implementazione open-source delle API OpenGL, OpenGL ES, Vulkan, OpenCL, e altri.

54. gstreamer1.0: Framework multimediale per la costruzione di applicazioni che elaborano flussi di dati audio e video.

55. gstreamer1.0-plugins-base: Plugin di base per GStreamer, forniscono funzionalità fondamentali.

56. gstreamer1.0-plugins-good: Plugin "buoni" per GStreamer, forniscono funzionalità stabili e ben testate.

57. gstreamer1.0-plugins-bad: Plugin "cattivi" per GStreamer, contengono funzionalità meno mature o meno ben testate.

58. gstreamer1.0-plugins-ugly: Plugin "brutti" per GStreamer, contengono funzionalità che potrebbero avere problemi di licenza.

59. ffmpeg: Strumento multimediale per la registrazione, conversione e streaming di audio e video.


## Build on your host machine
Tested host configuration:<br/>
Host machine:<br/> 
- Ubuntu 20.04.6 LTS (Focal Fossa)<br>
- Debian 12 <br>

Hardware name:<br/>
- Raspberry Pi 4 Model B Rev 1.4 (DT)<br/>

The building process could arise some warning due to some features in development.<br>
KAS 4 provide an easy way to collect the sources, setup the environment and start the build process.<br>
Install kas :<br/>
> pip3 install kas<br/>

clone this manifest :<br/>

> git clone \<URL to manifest\><br/>
> cd  bunch-linux-manifests<br/>

Start the to build the system: <br/>

> git pull <br>
> kas build kas/bunch-linux-demo.yml --update --force-checkout<br/>

It could take a while depending on the power of the machine used to compile. <br/>

##### Deploy
The compiled image will be located into the build folder at the following path:
> /build/tmp/deploy/images/raspberrypi4-64

Getting the image it should be flashed through linux dd, bmaptool command or using third party software like *BalenaEtcher*, *Raspberry* *Imager*.

> bunzip2 -c bunch-linux-demo-bunch-raspberrypi4-64.wic.bz2 \| sudo dd of=/dev/sda bs=1M  status=progress && sync

> bmaptool copy \<IMAGE\>.wic.gz /dev/sda && sync

##### Development
To get the SDK run :

> kas shell kas/bunch-linux.yml --update --force-checkout<br>
> bitbake -c populate_sdk bunch-linux-demo <br>

at the end of the build the SDK will be placed in :
> /build/tmp/deploy/sdk/raspberrypi4-64 <br>
