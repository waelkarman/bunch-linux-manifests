# DNN module (cv2.dnn) for object-detector: runs the YOLO11n ONNX model.
PACKAGECONFIG:append:class-target = " dnn"

# OpenCV (dnn, gapi) compiles units of 1-2 GB each: fewer jobs so that it does not
# run the host out of memory next to the other recipes building in parallel.
PARALLEL_MAKE = "-j 6"
