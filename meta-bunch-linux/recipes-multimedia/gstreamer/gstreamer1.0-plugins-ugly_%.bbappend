# NOTE: gstreamer1.0-plugins-ugly has LICENSE_FLAGS = "commercial": building it
# needs LICENSE_FLAGS_ACCEPTED += "commercial" (check the licenses first).
PACKAGECONFIG:append = " a52dec mpeg2dec x264"
