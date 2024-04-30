#!/usr/bin/env sh

set -euxo pipefail

# Enable SysRq
echo 'kernel.sysrq = 1' > /usr/lib/sysctl.d/90-sysrq.conf

# Disable SELinux
sed -i 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config

# Enable/mask some services by default
ln -sf /usr/lib/systemd/system/systemd-timesyncd.service /etc/systemd/system/dbus-org.freedesktop.timesync1.service
ln -sf /usr/lib/systemd/system/systemd-timesyncd.service /etc/systemd/system/sysinit.target.wants/systemd-timesyncd.service
ln -sf /usr/lib/systemd/system/docker.service /etc/systemd/system/multi-user.target.wants/docker.service
ln -sf /usr/lib/systemd/system/fstrim.timer /etc/systemd/system/timers.target.wants/fstrim.timer
ln -sf /dev/null /etc/systemd/system/avahi-daemon.service
ln -sf /dev/null /etc/systemd/system/avahi-daemon.socket

# Allow uinput group to access uinput for ydotool usage
tee /usr/lib/udev/rules.d/80-uinput.rules << "EOF"
# ydotoold fix
# https://github.com/ReimuNotMoe/ydotool/issues/25#issuecomment-535842993
KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
EOF

# Copy created users and groups over
grep -vE "^(root|wheel):" /etc/group >> /usr/lib/group
grep -v "^root:" /etc/passwd >> /usr/lib/passwd

# Restore default users
tee /etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
EOF

# Restore default groups
tee /etc/group << "EOF"
root:x:0:
wheel:x:10:
EOF

# Add some default available groups
grep -E '^vboxusers:' /usr/lib/group | tee -a /etc/group
grep -E '^docker:' /usr/lib/group | tee -a /etc/group
grep -E '^input:' /usr/lib/group | tee -a /etc/group
grep -E '^dialout:' /usr/lib/group | tee -a /etc/group
