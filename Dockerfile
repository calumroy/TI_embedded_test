# Use Ubuntu 22.04 as base image
FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

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
    && rm -rf /var/lib/apt/lists/*

# Optional: symlink python3 -> python3.9 or python for convenience
RUN ln -sf /usr/bin/python3.9 /usr/bin/python3 && ln -sf /usr/bin/python3.9 /usr/bin/python

# Create and use a virtual environment for Python packages
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install Python packages in the virtual environment
RUN pip install --no-cache-dir pyserial xmodem tqdm pyelftools construct

# Create a working directory
WORKDIR /app

# Copy the run files (replace with your actual installation artifacts)
COPY mcu_plus_sdk_am263px_10_01_00_34-linux-x64-installer.run /app/
COPY sysconfig-1.23.0_4000-setup.run /app/
COPY uniflash_sl.9.1.0.5175.run /app/
COPY README.md /app/

# Copy the installation script
COPY install_ccs.sh /app/

# Copy the CCS directory
COPY CCS_20.1.0.00006_linux /app/CCS_20.1.0.00006_linux/

# Make the run files executable
RUN chmod +x /app/*.run && \
    chmod +x /app/CCS_20.1.0.00006_linux/ccs_setup_20.1.0.00006.run

# Make the installation script executable
RUN chmod +x /app/install_ccs.sh

# Default to a bash shell
CMD ["/bin/bash"]