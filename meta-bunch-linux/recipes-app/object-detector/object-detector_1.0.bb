SUMMARY = "Real-time object detection from the webcam (YOLO11n on OpenCV DNN)"
DESCRIPTION = "Python3/OpenCV app: opens a V4L2 (USB UVC) camera, runs the YOLO11n \
COCO model exported to ONNX with the OpenCV DNN module (no PyTorch) and shows \
the detections, labelled in Italian, in a GTK window on Weston."
# The app is project code; the YOLO11n weights (yolo11n.onnx) are Ultralytics AGPL-3.0.
LICENSE = "CLOSED & AGPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/AGPL-3.0-only;md5=73f1eb20517c55bf9493b7dd6e480788"
LICENSE:${PN} = "CLOSED & AGPL-3.0-only"

# Model exported on the host from the desktop project with:
#   yolo export model=yolo11n.pt format=onnx imgsz=320 opset=12 simplify=True
SRC_URI = " \
    file://object-detector.py \
    file://object-detector \
    file://yolo11n.onnx \
"

S = "${UNPACKDIR}"

inherit allarch

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
    install -Dm 0755 ${S}/object-detector ${D}${bindir}/object-detector
    install -Dm 0644 ${S}/object-detector.py ${D}${datadir}/object-detector/object-detector.py
    install -Dm 0644 ${S}/yolo11n.onnx ${D}${datadir}/object-detector/yolo11n.onnx
}

FILES:${PN} = "${bindir}/object-detector ${datadir}/object-detector"

# python3-opencv needs the dnn module: see recipes-support/opencv/opencv_%.bbappend
RDEPENDS:${PN} = "python3-core python3-opencv python3-numpy v4l-utils"
# USB (UVC) webcams: module from the RPi kernel and from linux-yocto (QEMU, webcam.cfg)
RRECOMMENDS:${PN} = "kernel-module-uvcvideo"
