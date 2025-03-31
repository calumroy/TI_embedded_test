# Use Debian 11 as base image
FROM debian:11

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Enable i386 architecture and install dependencies
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y \
    libpython3.9 \
    libc6:i386 \
    && rm -rf /var/lib/apt/lists/*

# Install required packages
RUN apt-get update && apt-get install -y \
    python3 \
    python3-full \
    python3-venv \
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
    && rm -rf /var/lib/apt/lists/*

# Create symbolic link for python3
RUN ln -sf /usr/bin/python3 /usr/bin/python

# Create and use a virtual environment for Python packages
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install Python packages in the virtual environment
RUN /opt/venv/bin/pip install pyserial xmodem tqdm pyelftools construct

# Create a working directory
WORKDIR /app

# Copy the run files
COPY mcu_plus_sdk_am263px_10_01_00_34-linux-x64-installer.run /app/
COPY sysconfig-1.23.0_4000-setup.run /app/
COPY uniflash_sl.9.1.0.5175.run /app/
COPY README.md /app/
# Copy the installation script
COPY install_ccs.sh /app/

# Copy the CCS directory
COPY CCS_20.1.0.00006_linux /app/CCS_20.1.0.00006_linux/

# Make the run files executable
RUN chmod +x /app/*.run
RUN chmod +x /app/CCS_20.1.0.00006_linux/ccs_setup_20.1.0.00006.run

# Make the installation script executable
RUN chmod +x /app/install_ccs.sh

# Set the PATH to include the virtual environment
ENV PATH="/opt/venv/bin:$PATH"

# Set the default command to bash
CMD ["/bin/bash"] 