# Sericea - Fedora OSTree-based Sway Build

This repository contains a customized Sericea (Sway) build that can be used to rebase Fedora OSTree-based systems like Silverblue or Kinoite. It is based on the `quay.io/fedora-ostree-desktops/sericea` image with added custom packages, including nwg-shell.

## Overview
OSTree is a tool that provides a Git-like experience but for managing binary files, particularly, an operating system's binary files. This functionality has been extended to support OCI/Docker containers, elevating them to be used as a transport mechanism for bootable operating systems. This model is currently classified as experimental but is rapidly heading towards stabilization.

## Rebasing a client system
You can use this build to switch to booting from a container image by executing the following command:

```sh
$ rpm-ostree rebase ostree-unverified-registry:ghcr.io/cryptoluks/fedora-oci/sericea
```

## Upgrading
After a rebase, all further rpm-ostree operations work as expected. For instance, rpm-ostree upgrade will look for a new container version. You can also use rpm-ostree apply-live and other similar commands.
