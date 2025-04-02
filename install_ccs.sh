#!/bin/bash

# Install MCU SDK
echo "Installing MCU SDK..."
/app/mcu_plus_sdk_am263px_10_01_00_34-linux-x64-installer.run --mode unattended --prefix /opt/ti/mcu_plus_sdk
echo "MCU SDK installation complete."

# Install CLANG compiler
echo "Installing CLANG compiler..."
/app/ti_cgt_armllvm_4.0.1.LTS_linux-x64_installer.bin --mode unattended --prefix /opt/ti/clang
echo "CLANG compiler installation complete."

# Install sysconfig 
echo "Installing sysconfig..."
/app/sysconfig-1.23.0_4000-setup.run --mode unattended --prefix /opt/ti/sysconfig
echo "sysconfig installation complete."

# Install uniflash
echo "Installing Uniflash..."
/app/uniflash_sl.9.1.0.5175.run --mode unattended --prefix /opt/ti/uniflash
echo "Uniflash installation complete."

echo "Installing Code Composer Studio For the PF_SITARA_MCU components of Codecomposer Studio..."
/app/CCS_20.1.0.00006_linux/ccs_setup_20.1.0.00006.run --mode unattended --prefix /opt/ti/ccs --enable-components PF_SITARA_MCU
echo "CCS installation complete."

