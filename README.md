# TI_embedded_test
A project to test building embedded  C code for Texas Instruments embedded microcontrollers such as the AM263P chips. 

Builds the project in a docker container containing all the required TI software and libraries.

This project expects the following files which can be downloaded from TI:

  * mcu_plus_sdk_am263px_10_01_00_34-linux-x64-installer.run
  * sysconfig-1.23.0_4000-setup.run
  * uniflash_sl.9.1.0.5175.run
  * CCS_20.1.0.00006_linux/ccs_setup_20.1.0.00006.run

CCS_20.1.0.00006_linux (Code composer form TI website).

## Build container from the Dockerfile
```
podman build -t ti_embedded_test .
```

## Start the container
In linux using X11 and using podman instead of docker. 
If you need to run CCS with its GUI, you'll need to enable X11 forwarding:
```
podman run -it --net=host -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix ti_embedded_test
```

If you don't need to run the codecomposer GUI application and just want an enviroment to build a project then just start the conatiner with
```
podman run -it ti_embedded_test
```

