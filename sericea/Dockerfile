ARG PKGS_SRC
ARG SRC

FROM "$PKGS_SRC" as packages
FROM "$SRC"

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

# VirtualBox kernel modules and guest additions
COPY --from=packages /rpms /tmp/rpms
COPY build.sh /build.sh
RUN chmod +x /build.sh && /build.sh && ostree container commit

# Glow - render markdown on the CLI
RUN <<-EOF
    echo -e '[charm]\nname=Charm\nbaseurl=https://repo.charm.sh/yum/\nenabled=1\ngpgcheck=1\ngpgkey=https://repo.charm.sh/yum/gpg.key' > /etc/yum.repos.d/charm.repo
    rpm-ostree install glow
    ostree container commit
EOF

# Pet - CLI snippet manager
RUN curl -s https://api.github.com/repos/knqyf263/pet/releases/latest | jq -r '.assets[] | select(.name | test("linux_amd64.tar.gz")) | .browser_download_url' | xargs -I {} curl -sS -L {} | tar xz -O pet > /tmp/pet && mv /tmp/pet /usr/bin/ && chmod +x /usr/bin/pet

# Terraform, Packer, Vagrant
RUN <<-EOF
    wget --progress=bar:force:noscroll https://rpm.releases.hashicorp.com/fedora/hashicorp.repo -O /etc/yum.repos.d/hashicorp.repo
    mkdir /var/opt
    rpm-ostree install packer terraform vagrant
    mv /var/opt/vagrant /usr/lib/
    echo 'L /opt/vagrant - - - - ../../usr/lib/vagrant' > /usr/lib/tmpfiles.d/vagrant.conf
    rmdir /var/opt
    ostree container commit
EOF

# Microsoft Edge
RUN <<-EOF
    wget --progress=bar:force:noscroll https://packages.microsoft.com/yumrepos/edge/config.repo -O /etc/yum.repos.d/edge.repo
    mkdir /var/opt
    rpm-ostree install microsoft-edge-stable
    mv /var/opt/microsoft /usr/lib/
    echo 'L /opt/microsoft - - - - ../../usr/lib/microsoft' > /usr/lib/tmpfiles.d/microsoft.conf
    rmdir /var/opt
    ostree container commit
EOF

# VSCode
RUN <<-EOF
    wget --progress=bar:force:noscroll https://packages.microsoft.com/yumrepos/vscode/config.repo -O /etc/yum.repos.d/vscode.repo
    rpm-ostree install code
    ostree container commit
EOF

# Swayr - urgent-first/LRU window switcher for Sway
RUN <<-EOF
    wget --progress=bar:force:noscroll https://copr.fedorainfracloud.org/coprs/alebastr/swayr/repo/fedora-39/alebastr-swayr-fedora-39.repo -O /etc/yum.repos.d/swayr.repo
    rpm-ostree install swayr
    ostree container commit
EOF

# Nwg tools
RUN <<-EOF
    wget --progress=bar:force:noscroll https://copr.fedorainfracloud.org/coprs/tofik/nwg-shell/repo/fedora-39/tofik-nwg-shell-fedora-39.repo -O /etc/yum.repos.d/nwg-shell.repo
    rpm-ostree install \
        nwg-bar \
        nwg-displays \
        nwg-look \
        nwg-shell-config \
        swaync
    ostree container commit
EOF

# Docker
RUN <<-EOF
    wget --progress=bar:force:noscroll https://download.docker.com/linux/fedora/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo
    rpm-ostree install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras
EOF

# Google Chrome
RUN <<-EOF
    sed -i 's/enabled=0/enabled=1/' /etc/yum.repos.d/google-chrome.repo
    rpm --import https://dl.google.com/linux/linux_signing_key.pub
    mkdir /var/opt
    rpm-ostree install google-chrome-stable
    mv /var/opt/google /usr/lib/
    echo 'L /opt/google - - - - ../../usr/lib/google' > /usr/lib/tmpfiles.d/google.conf
    rmdir /var/opt
    ostree container commit
EOF

# Other
RUN <<-EOF
    rpm-ostree install \
        android-tools \
        ansible \
        arc-kde \
        arc-theme \
        bat \
        binutils \
        borgmatic \
        btop \
        celluloid \
        chromium \
        clipman \
        dconf-editor \
        direnv \
        distrobox \
        eog \
        evince \
        eza \
        fd-find \
        firefox \
        fish \
        flatpak-builder \
        fuse-sshfs \
        fzf \
        glab \
        gnome-boxes \
        gstreamer1-plugin-openh264 \
        hadolint \
        htop \
        intel-media-driver \
        just \
        keepassxc \
        libimobiledevice-utils \
        libusbmuxd-utils \
        lm_sensors \
        mosh \
        mozilla-openh264 \
        neovim \
        net-tools \
        NetworkManager-tui \
        nmap \
        openh264 \
        pass \
        gopass \
        pipenv \
        poetry \
        proxychains-ng \
        python3-pip \
        qt5ct \
        rclone \
        ripgrep \
        spacefm \
        smartmontools \
        socat \
        speedcrunch \
        swappy \
        sysstat \
        thefuck \
        thunderbird \
        tldr \
        tmux \
        usbmuxd \
        virt-manager \
        vlc \
        wireguard-tools \
        wl-clipboard \
        wlsunset \
        wofi \
        xarchiver \
        ydotool \
        zoxide \
        zsh \
        zstd
    rm -rf /var/*
    ostree container commit
EOF

# Apply settings
COPY post.sh /post.sh
RUN chmod +x /post.sh && /post.sh && ostree container commit

# Add Firefox policies.json
COPY post/policies.json /etc/firefox/policies/policies.json

SHELL ["/bin/sh", "-c"]
