#!/usr/bin/env sh

set -oeux pipefail

VERSION_FILE="/kernel-version.txt"
KERNEL_VERSION=$(cat ${VERSION_FILE})

dnf -y install \
    fedora-repos-archive

dnf -y install \
    kernel-${KERNEL_VERSION} \
    kernel-devel-${KERNEL_VERSION}

dnf -y install \
    akmods \
    fedpkg \
    mock \
    wget
