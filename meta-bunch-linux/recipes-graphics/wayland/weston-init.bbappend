FILESEXTRAPATHS:prepend := "${THISDIR}/weston-init/:"

SRC_URI =  "file://init \
            file://weston.env \
            file://weston.ini \
            file://weston.service \
            file://weston.socket \
            file://weston-socket.sh \
            file://weston-autologin \
        	file://weston-start \
			file://server.key \
		    file://server.crt \
		   "