ARG PKGS_SRC
ARG SRC

FROM "${PKGS_SRC}" as packages
FROM "${SRC}"

# virtualbox kernel modules and additions
COPY --from=packages /rpms /tmp/rpms
COPY build.sh /build.sh
RUN chmod +x /build.sh && /build.sh \
  && ostree container commit

# ffmpeg
RUN rpm-ostree override remove \
  libavcodec-free \
  libavfilter-free \
  libavformat-free \
  libavutil-free \
  libpostproc-free \
  libswresample-free \
  libswscale-free \
  --install ffmpeg \
  && ostree container commit

# vscode
RUN echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo \
  && rpm-ostree install code \
  && ostree container commit

# nwg-shell
RUN wget --progress=bar:force:noscroll https://copr.fedorainfracloud.org/coprs/tofik/nwg-shell/repo/fedora-$version/tofik-nwg-shell-fedora-$version.repo -O /etc/yum.repos.d/nwg-shell.repo \
  && wget --progress=bar:force:noscroll https://copr.fedorainfracloud.org/coprs/notahat/pamixer/repo/fedora-$version/notahat-pamixer-fedora-$version.repo -O /etc/yum.repos.d/pamixer.repo \
  && rpm-ostree install nwg-shell \
  && ostree container commit

# element-desktop
RUN wget --progress=bar:force:noscroll https://download.opensuse.org/repositories/home:jejb1:Element/Fedora_38/home:jejb1:Element.repo -O /etc/yum.repos.d/element.repo \
  && rpm-ostree install element-desktop \
  && ostree container commit

# tailscale
RUN wget --progress=bar:force:noscroll https://pkgs.tailscale.com/stable/fedora/tailscale.repo -O /etc/yum.repos.d/tailscale.repo \
  && rpm-ostree install tailscale \
  && ostree container commit

# docker-ce
RUN wget --progress=bar:force:noscroll https://download.docker.com/linux/fedora/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo \
  && rpm-ostree install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# terraform, packer
RUN wget --progress=bar:force:noscroll https://rpm.releases.hashicorp.com/fedora/hashicorp.repo -O /etc/yum.repos.d/hashicorp.repo \
  && sed -i -e '/^\[hashicorp\]/,/^\[/ s/^\(name=.*\)$/\1\npriority=100/' -e '/^\[hashicorp-test\]/,/^\[/ s/^\(name=.*\)$/\1\npriority=100/' /etc/yum.repos.d/hashicorp.repo \
  && rpm-ostree install packer terraform \
  && ostree container commit

# teams for linux
RUN wget --progress=bar:force:noscroll https://repo.teamsforlinux.de/rpm/teams-for-linux.repo -O /etc/yum.repos.d/teams-for-linux.repo \
  && echo 'gpgkey=https://repo.teamsforlinux.de/teams-for-linux.asc' | tee -a /etc/yum.repos.d/teams-for-linux.repo \
  && rpm-ostree install teams-for-linux \
  && ostree container commit

# other packages
RUN rpm-ostree install \
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
  distrobox \
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
  thunderbird \
  tmux \
  usbmuxd \
  vagrant \
  virt-manager \
  vlc \
  wireguard-tools \
  wl-clipboard \
  xarchiver \
  ydotool \
  zoxide \
  zsh \
  zstd \
  && rm -rf /var/* \
  && ostree container commit

COPY post.sh /post.sh
RUN chmod +x /post.sh && /post.sh \
  && ostree container commit

# Add firefox policies.json to add default addons/settings
COPY post/policies.json /etc/firefox/policies/policies.json
