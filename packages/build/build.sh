#!/usr/bin/env sh

set -euxo pipefail

KERNEL="$(rpm -q kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"
RELEASE="$(rpm -E '%fedora')"
RPMDIR=/var/cache/rpms

dnf -y install wget &&
    wget --progress=bar:force:noscroll -P $RPMDIR \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$RELEASE.noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$RELEASE.noarch.rpm &&
    dnf -y install $RPMDIR/rpmfusion-*.rpm

dnf -y install VirtualBox &&
    akmods --force --kernels "$KERNEL"

VERSION="$(curl -s http://download.virtualbox.org/virtualbox/LATEST.TXT)"
EXT_PACK="Oracle_VM_VirtualBox_Extension_Pack-$VERSION.vbox-extpack"

if [ ! -f "$EXT_PACK" ]; then
    wget https://download.virtualbox.org/virtualbox/"$VERSION"/"$EXT_PACK" -O "$EXT_PACK"
fi

sed -i "s/_VERSION_/$VERSION/" vbox-extensions-pack.spec
fedpkg --release f39 local
