# Use Ubuntu 22.04 as base image
FROM ubuntu:22.04

###############################################################################
# 1) Install systemd/udev so that Blackhawk driver scripts (service udev reload)
#    can succeed. We also install dbus so systemd can function properly.
###############################################################################
ENV container docker
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      systemd \
      systemd-sysv \
      udev \
      dbus \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set a default locale (optional, helps avoid locale warnings)
RUN apt-get update && \
    apt-get install -y locales && \
    locale-gen en_US.UTF-8 && \
    rm -rf /var/lib/apt/lists/*
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

###############################################################################
# 2) Rest of your original Dockerfile steps
###############################################################################

# Enable i386 architecture (if Code Composer or other tooling needs it)
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y \
    software-properties-common \
    gnupg \
    ca-certificates \
    libc6:i386 \
    && rm -rf /var/lib/apt/lists/*

# Add deadsnakes PPA for Python 3.9
RUN add-apt-repository ppa:deadsnakes/ppa && apt-get update && \
    apt-get install -y \
    python3.9 \
    python3.9-dev \
    python3.9-venv \
    python3.9-distutils \
    python3-pip \
    wget \
    build-essential \
    openssl \
    mono-runtime \
    unzip \
    libxtst6 \
    libxrender1 \
    libgtk-3-0 \
    xterm \
    libasound2 \
    libdrm2 \
    libgbm1 \
    libnspr4 \
    libnss3 \
    libnss3-tools \
    libsecret-1-0 \
    libtinfo5 \
    libusb-0.1-4 \
    libusb-1.0-0 \
    libxkbfile1 \
    iputils-ping \
    net-tools \
    curl \
    iproute2 \
    libcanberra-gtk-module \
    libcanberra-gtk3-module \
    libcanberra0 \
    libgconf-2-4 \
    xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# Optional: symlink python3 -> python3.9 or python -> python3.9
RUN ln -sf /usr/bin/python3.9 /usr/bin/python3 && \
    ln -sf /usr/bin/python3.9 /usr/bin/python

# Create and use a Python venv
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install Python packages
RUN pip install --no-cache-dir pyserial xmodem tqdm pyelftools construct cryptography

# Create a working directory
WORKDIR /app

# Copy your run files (adjust filenames/paths as needed)
COPY mcu_plus_sdk_am263px_10_01_00_34-linux-x64-installer.run /app/
COPY sysconfig-1.23.0_4000-setup.run /app/
COPY uniflash_sl.9.1.0.5175.run /app/
COPY README.md /app/
COPY install_ccs.sh /app/
COPY CCS_20.1.1.00008_linux /app/CCS_20.1.1.00008_linux/
COPY ti_cgt_armllvm_4.0.1.LTS_linux-x64_installer.bin /app/

# Make run files and script executable
RUN chmod +x /app/*.run && \
    chmod +x /app/CCS_20.1.1.00008_linux/ccs_setup_20.1.1.00008.run && \
    chmod +x /app/install_ccs.sh && \
    chmod +x /app/ti_cgt_armllvm_4.0.1.LTS_linux-x64_installer.bin && \
    chmod +x /app/sysconfig-1.23.0_4000-setup.run && \
    chmod +x /app/mcu_plus_sdk_am263px_10_01_00_34-linux-x64-installer.run && \
    chmod +x /app/uniflash_sl.9.1.0.5175.run

# Install passwd if it isn't already
RUN apt-get update && apt-get install -y passwd

# Set root password to "root" (or choose something else).
# Obviously, for real usage pick a more secure password.
RUN echo "root:root" | chpasswd

# Install CCS during build
RUN /app/install_ccs.sh

# Add CCS Studio to PATH and create alias
ENV PATH="/opt/ti/ccs/ccs/theia:${PATH}"
RUN echo 'alias ccstudio="/opt/ti/ccs/ccs/theia/ccstudio --no-sandbox"' >> /root/.bashrc

# /opt/ti/uniflash/node-webkit/nw /opt/ti/uniflash
RUN echo 'export PATH="/opt/ti/uniflash/node-webkit/nw:$PATH"' >> /root/.bashrc
RUN echo 'alias uniflash="/opt/ti/uniflash/node-webkit/nw /opt/ti/uniflash"' >> /root/.bashrc 

# Install USB utilities and LSB release information
RUN apt-get update && apt-get install -y usbutils lsb-release && \
    rm -rf /var/lib/apt/lists/*

###############################################################################
# 3) Configure the container to run systemd by default
###############################################################################
STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
