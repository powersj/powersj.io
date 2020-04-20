---
title: "Ubuntu 19.10 Released"
date: 2019-10-24
tags: ["ubuntu"]
draft: false
---

![Banner](/img/ubuntu/eoan.jpg#center)

The next development release of Ubuntu, the Eoan Ermine, was [released last week](https://lists.ubuntu.com/archives/ubuntu-announce/2019-October/000250.html)! This was the last development release before our upcoming LTS, codenamed Focal Fossa. As a result, lots of bug fixes, new features, and experience improvements have made their way into the release.

Some highlights include:

* New GNOME version to 3.34
* Further refinement to the desktop yaro theme
* Latest upstream stable kernel 5.3
* OpenSSL 1.1.1 support
* Experimental ZFS on root support in the desktop installer
* OpenStack Train support

See the [release notes](https://wiki.ubuntu.com/EoanErmine/ReleaseNotes) for more details.

## Ubuntu Server

Ubuntu Server comes refreshed with new major versions of the virtualization stack with qemu 4.0 and libvirt 5.6. We also were able to move mysql 8.0 and PHP up to 7.3. There are of course numerous other packages that received bug fixes, new features and versions as well thanks to the great work by the Canonical team, countless community members and partners.

The subiquity based Server installer continues to see improvements made. As more users are able to try out and even adopt the new installer new bugs are found and fixed. This is done quickly due to the ability to update the installer before actually doing an install. We are able to keep users going with new fixes rather than needing to wait for point releases to provide new ISOs.

We also announced formal support for the arm64 and ppc64el architectures with the subiquity installer. The last architecture, s390x, will come next cycle.

The release comes with support for latest release of OpenStack codenamed Train and a new QCOW2 image was added as a KVM optimized image, which contain the linux-kvm kernel.

## My Desktop Experience

This has been one of the fastest, clean looking Ubuntu releases that I can remember. The yaru theme is one of my all time favorite for how responsive and polished it has come out looking.

The overall performance of GNOME seems to have improved greatly and provides a very smooth and sleek experience. I have enjoyed watching our GNOME desktop evolve and improve over the past few releases. So much so that I have not even looked at any of the other desktop environments in a while.

I have yet to try out the ZFS on root support, but I am very interested in doing so. When I saw a demo of the power that comes with snapshot and rollback support it is easy to see how exciting this is.

## Onward to Focal

We shall continue the focus we have had on improving the features, security, and stability in Ubuntu, as we develop our next LTS, Focal Fossa. Here is to a great release and an even more stable and feature rich LTS in 2020!
