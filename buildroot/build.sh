#!/usr/bin/env sh

set -euxo pipefail

KERNEL_VERSION=$(cat /kernel-version.txt)

dnf -y install \
    fedora-repos-archive

dnf -y install \
    kernel-$KERNEL_VERSION \
    kernel-devel-$KERNEL_VERSION

dnf -y install \
    akmods \
    fedpkg \
    mock \
    wget
