docker run -d --name=piraeus-controller -p 3370:3370 quay.io/piraeusdatastore/piraeus-server startController



docker run -d --name=piraeus-satellite --net=host --privileged --cap-add=SYS_ADMIN -v /dev:/dev -v /sys/kernel/config:/sys/kernel/config quay.io/piraeusdatastore/piraeus-server startSatellite