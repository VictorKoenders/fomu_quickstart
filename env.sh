#!/bin/bash

set -e

# This script tries to configure a user's environment
# First, this script checks if the `tools` folder exists
# If this directory does not exist, it will prompt the user to download the famo fpga tools from github

# Afterwards the script will append the ./tools/fomu-toolchain/bin to $PATH

if [[ ! -d "tools/fomu-toolchain" ]]; then
    echo "Could not find fomu-toolchain (searched in 'tools/fomu-toolchain')"
    echo "Do you want to automatically download this?"
    echo "  (we'll download a .tar.gz from the internet and extract it)"

    read -p "Download fomu toolchain? [y/N]" -n 1 -r
    echo    # (optional) move to a new line
    if [[ ! "$REPLY" =~ ^[Yy]$ ]]
    then
        set +e
        exit 1
    fi

    FOMU_TOOLCHAIN_VERSION="v1.5.3"

    mkdir -p tools
    pushd tools > /dev/null
    wget https://github.com/im-tomu/fomu-toolchain/releases/download/$FOMU_TOOLCHAIN_VERSION/fomu-toolchain-linux_x86_64-$FOMU_TOOLCHAIN_VERSION.tar.gz
    tar -xvf fomu-toolchain-linux_x86_64-$FOMU_TOOLCHAIN_VERSION.tar.gz
    rm fomu-toolchain-linux_x86_64-$FOMU_TOOLCHAIN_VERSION.tar.gz
    mv fomu-toolchain-linux_x86_64-$FOMU_TOOLCHAIN_VERSION fomu-toolchain
    popd
fi

if [[ ! -f /etc/udev/rules.d/99-fomu.rules ]]; then
    echo "/etc/udev/rules.d/99-fomu.rules not found"
    echo "Do you want to create this? (Requires sudo)"
    echo "  echo SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"1209\", ATTRS{idProduct}==\"5bf0\", MODE=\"0664\", GROUP=\"plugdev\" | sudo tee /etc/udev/rules.d/99-fomu.rules"
    echo "  sudo udevadm control --reload-rules"
    echo "  sudo udevadm trigger"
    read -p "Run command? [y/N]" -n 1 -r
    echo    # (optional) move to a new line
    if [[ ! "$REPLY" =~ ^[Yy]$ ]]
    then
        set +e
        exit 1
    fi
    echo SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"1209\", ATTRS{idProduct}==\"5bf0\", MODE=\"0664\", GROUP=\"plugdev\" | sudo tee /etc/udev/rules.d/99-fomu.rules
    sudo udevadm control --reload-rules
    sudo udevadm trigger
fi

echo export PATH=`pwd`/tools/fomu-toolchain/bin:$PATH
export PATH=`pwd`/tools/fomu-toolchain/bin:$PATH

set +e