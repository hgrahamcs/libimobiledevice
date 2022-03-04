# Written by henry@hgrahamcs.com for libimobiledevice/libimobiledevice
# Current issue: Passing device from host to container and having usbmuxd pick it up.
# Run using: docker run -t -i --device=/path/to/device <container> 
# More dangerous version: docker run -t -i --privileged -v /dev/bus/usb:/dev/bus/usb <container>
FROM debian:bullseye

RUN apt-get update -y
RUN apt-get install -y build-essential checkinstall git autoconf automake libtool-bin python3 cython3 pkg-config libssl-dev libusb-1.0.0-dev udev

#LIBPLIST
RUN git clone https://github.com/libimobiledevice/libplist.git
WORKDIR libplist
RUN ./autogen.sh
RUN make -j `nproc`
RUN make install
WORKDIR ..

#LIBMOBILDEVICE-GLUE
RUN git clone https://github.com/libimobiledevice/libimobiledevice-glue.git
WORKDIR libimobiledevice-glue
RUN ./autogen.sh
RUN make -j `nproc`
RUN make install
WORKDIR ..

#LIBUSBMUXD
RUN git clone https://github.com/libimobiledevice/libusbmuxd.git
WORKDIR libusbmuxd
RUN ./autogen.sh
RUN make -j `nproc`
RUN make install
WORKDIR ..

#LIBIMOBILEDEVICE
RUN git clone https://github.com/libimobiledevice/libimobiledevice.git
WORKDIR libimobiledevice
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN ./autogen.sh
RUN make -j `nproc`
RUN make install
WORKDIR ..

#USBMUXD
RUN git clone https://github.com/libimobiledevice/usbmuxd.git
WORKDIR usbmuxd
RUN ./autogen.sh
RUN make -j `nproc`
RUN make install
WORKDIR ..

# prep for use
RUN ldconfig #if this isn't done usbmuxd didn't pick up a relevant libs
