ARG PKGS_SRC
ARG SRC

FROM "${PKGS_SRC}" as packages
FROM "${SRC}"

# virtualbox kernel modules and additions
COPY --from=packages /rpms /tmp/rpms
COPY build.sh /build.sh
RUN chmod +x /build.sh && /build.sh && ostree container commit

# terraform, packer, vagrant
RUN <<-EOF
  set -eux
  wget --progress=bar:force:noscroll https://rpm.releases.hashicorp.com/fedora/hashicorp.repo -O /etc/yum.repos.d/hashicorp.repo
  mkdir /var/opt
  rpm-ostree install packer terraform vagrant
  mv /var/opt/vagrant /usr/lib/
  echo 'L /opt/vagrant - - - - ../../usr/lib/vagrant' > /usr/lib/tmpfiles.d/vagrant.conf
  rmdir /var/opt
  ostree container commit
EOF

# edge, pin version as most recent stable has invalid signature
RUN <<-EOF
  set -eux
  wget --progress=bar:force:noscroll https://packages.microsoft.com/yumrepos/edge/config.repo -O /etc/yum.repos.d/edge.repo
  mkdir /var/opt
  rpm-ostree install microsoft-edge-stable-114.0.1823.82
  mv /var/opt/microsoft /usr/lib/
  echo 'L /opt/microsoft - - - - ../../usr/lib/microsoft' > /usr/lib/tmpfiles.d/microsoft.conf
  rmdir /var/opt
  ostree container commit
EOF

# vscode, pin version as with edge
RUN <<-EOF
  set -eux
  wget --progress=bar:force:noscroll https://packages.microsoft.com/yumrepos/vscode/config.repo -O /etc/yum.repos.d/vscode.repo
  rpm-ostree install code-1.80.0
  ostree container commit
EOF

# nwg-shell
RUN <<-EOF
  set -eux
  wget --progress=bar:force:noscroll https://copr.fedorainfracloud.org/coprs/tofik/nwg-shell/repo/fedora-38/tofik-nwg-shell-fedora-38.repo -O /etc/yum.repos.d/nwg-shell.repo
  rpm-ostree install nwg-shell
  ostree container commit
EOF

# element
RUN <<-EOF
  set -eux
  wget --progress=bar:force:noscroll https://download.opensuse.org/repositories/home:jejb1:Element/Fedora_38/home:jejb1:Element.repo -O /etc/yum.repos.d/element.repo
  rpm-ostree install element-desktop
  ostree container commit
EOF

# tailscale
RUN <<-EOF
  set -eux
  wget --progress=bar:force:noscroll https://pkgs.tailscale.com/stable/fedora/tailscale.repo -O /etc/yum.repos.d/tailscale.repo
  rpm-ostree install tailscale
  ostree container commit
EOF

# docker
RUN <<-EOF
  set -eux
  wget --progress=bar:force:noscroll https://download.docker.com/linux/fedora/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo
  rpm-ostree install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras
EOF

# chrome
RUN <<-EOF
  set -eux
  sed -i 's/enabled=0/enabled=1/' /etc/yum.repos.d/google-chrome.repo
  rpm --import https://dl.google.com/linux/linux_signing_key.pub
  mkdir /var/opt
  rpm-ostree install google-chrome-stable
  mv /var/opt/google /usr/lib/
  echo 'L /opt/google - - - - ../../usr/lib/google' > /usr/lib/tmpfiles.d/google.conf
  rmdir /var/opt
  ostree container commit
EOF

# other packages
RUN <<-EOF
  set -eux
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
  dconf-editor \
  direnv \
  distrobox \
  eog \
  exa \
  fd-find \
  firefox \
  fish \
  flatpak-builder \
  fuse-sshfs \
  fzf \
  gnome-boxes \
  gstreamer1-plugin-openh264 \
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
  pipenv \
  poetry \
  proxychains-ng \
  python3-pip \
  qt5ct \	
  rclone \
  ripgrep \
  smartmontools \
  socat \
  speedcrunch \
  sysstat \
  thefuck \
  thunderbird \
  tmux \
  usbmuxd \
  virt-manager \
  vlc \
  wireguard-tools \
  wl-clipboard \
  xarchiver \
  ydotool \
  zoxide \
  zsh \
  zstd
  rm -rf /var/*
  ostree container commit
EOF

COPY post.sh /post.sh
RUN chmod +x /post.sh && /post.sh && ostree container commit

# Add firefox policies.json to add default addons/settings
COPY post/policies.json /etc/firefox/policies/policies.json
