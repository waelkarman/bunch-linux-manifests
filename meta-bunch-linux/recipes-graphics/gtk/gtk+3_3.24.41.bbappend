PACKAGECONFIG ??= " \
	${@bb.utils.filter('DISTRO_FEATURES', 'opengl x11', d)} \
	${@bb.utils.contains('DISTRO_FEATURES', 'opengl wayland', 'wayland', '', d)} \
    x11 opengl wayland cups \
"