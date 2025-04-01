#!/bin/bash
echo "Installing Code Composer Studio For the PF_SITARA_MCU components of Codecomposer Studio..."
/app/CCS_20.1.0.00006_linux/ccs_setup_20.1.0.00006.run --mode unattended --prefix /opt/ti/ccs --enable-components PF_SITARA_MCU
echo "CCS installation complete."

