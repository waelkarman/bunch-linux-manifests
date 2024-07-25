PACKAGECONFIG ??= "avdevice avfilter avcodec avformat swresample swscale postproc \
                   alsa bzlib lzma theora zlib xcb x264 x265 v4l2 sdl2 speex gpl alsa avcodec \
                   ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'xv xcb', '', d)}"