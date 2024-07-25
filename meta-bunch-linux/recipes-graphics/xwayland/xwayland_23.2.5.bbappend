PACKAGECONFIG = "${XORG_CRYPTO} \
                   ${@bb.utils.contains('DISTRO_FEATURES', 'opengl', '${OPENGL_PKGCONFIGS}', '', d)} \
                   dri3 \
                   glx \
                   glamor \
"