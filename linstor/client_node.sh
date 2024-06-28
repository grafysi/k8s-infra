docker run -d --name=satellite-client --cap-add=SYS_ADMIN --privileged --hostname=client --net=ipvlan_net --ip=192.168.100.89 -v ~/.grafysi/linstor-client:/mnt/nvmedata quay.io/piraeusdatastore/piraeus-server startSatellite

docker run -d --name=debian-vm --cap-add=SYS_ADMIN --privileged --net=ipvlan_net debian:latest /bin/bash -c "while true; do sleep 30; done"

docker run -d --name=debian-host --cap-add=SYS_ADMIN --privileged --net=host debian:latest /bin/bash -c "while true; do sleep 30; done"

docker run -d --name=ubuntu-vm --cap-add=SYS_ADMIN --privileged --net=ipvlan_net ubuntu:22.04 /bin/bash -c "while true; do sleep 30; done"