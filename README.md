# TI_embedded_test
A project to test building embedded  C code for Texas Instruments embedded microcontrollers such as the AM263P chips. 

Builds the project in a docker (or podman)container containing all the required TI software and libraries.

This project expects the following files which can be downloaded from TI:

  * mcu_plus_sdk_am263px_10_01_00_34-linux-x64-installer.run
  * sysconfig-1.23.0_4000-setup.run
  * uniflash_sl.9.1.0.5175.run
  * CCS_20.1.0.00006_linux/ccs_setup_20.1.0.00006.run

CCS_20.1.0.00006_linux (Code composer form TI website).

## Build container from the Dockerfile

Install podman and build the container.
Why podman or Docker?
Well podman makes it easier to run systemd inside the container and the ccstudio GUI application requires systemd to install and run.
Docker might work but is not tested, podman is essentially the same as docker (using all the same commands) but has improvements over docker.

```
podman build -t ti_embedded_test .
```

## Start the container
In linux using X11 and using podman instead of docker. 
If you need to run CCS with its GUI, you'll need to enable X11 forwarding:
```
podman run -d --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:rw -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY --name my-ti-container ti_embedded_test:latest

Now start a bash session in the container:
```
podman exec -it my-ti-container /bin/bash
```


