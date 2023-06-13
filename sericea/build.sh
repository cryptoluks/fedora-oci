#!/usr/bin/env sh

set -oeux pipefail

rpm-ostree install \
    /tmp/rpms/rpmfusion-*.rpm
    
rpm-ostree install \
    /tmp/rpms/VirtualBox-Extension-Pack-*.rpm \
    /tmp/rpms/kmod-VirtualBox-*.rpm \
    VirtualBox
