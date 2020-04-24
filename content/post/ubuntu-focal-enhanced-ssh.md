---
title: "Enhanced SSH 2FA in Ubuntu 20.04 LTS"
date: 2020-04-27
tags: ["ubuntu"]
draft: false
---

![Banner](/img/ubuntu/security.png#center)

Security is at the very heart of Ubuntu. At Canonical we strive to ensure Ubuntu is built with security in every aspect and improve the security offerings with each new release. This is not any different this time.

One of the most exciting security enhancements in [Ubuntu 20.04 LTS (Focal Fossa)](https://ubuntu.com/blog/ubuntu-20-04-lts-arrives) is the ability to use the Fast Identity Online (FIDO) or Universal 2nd Factor (U2F) devices with SSH. By using a second authentication factor via a device, users can add another layer of security to their infrastructure through a stronger and yet still easy to use mechanism for authentication. Ubuntu 20.04 LTS includes this feature out of the box through the latest version of [OpenSSH 8.2](https://www.openssh.com/txt/release-8.2).

For users, once keys are in place only a tap of the device is required to log in. For administrators looking to use FIDO or U2F on the server side all that is required is a version of OpenSSH server, 8.2 or newer, that supports the new key types.

The new public key types and certificates `ecdsa-sk` and `ed25519-sk` support such authentication devices. General handling of private and public key files is unchanged; users can still add a passphrase to the private key. By using a second factor the private SSH key alone is no longer enough to perform authentication. And as a result a compromised private key does not pose a threat.

The following section demonstrates how users can generate new key types and use them to perform authentication. First, users have to attach a device to the system. Next, they need to generate a new key and specify one of the new types. During this process users will get prompted to tap the token to confirm the operation:

```shell
ubuntu@focal-openssh-client:~$ ssh-keygen -t ecdsa-sk
Generating public/private ecdsa-sk key pair.
You may need to touch your authenticator to authorize key generation.
Enter file in which to save the key (/home/ubuntu/.ssh/id_ecdsa_sk):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/ubuntu/.ssh/id_ecdsa_sk
Your public key has been saved in /home/ubuntu/.ssh/id_ecdsa_sk.pub
```

Users can then confirm whether the new private and public keys were created:

```shell
ubuntu@focal-openssh-client:~$ l .ssh/id_ecdsa_sk*
-rw------- 1 ubuntu ubuntu 610 mar 30 17:58 .ssh/id_ecdsa_sk
-rw-r--r-- 1 ubuntu ubuntu 221 mar 30 17:58 .ssh/id_ecdsa_sk.pub
```

To use these keys all a user needs to do is copy the keys as they would do normally, using ssh-copy-id . This is done by ensuring the public key is added to ~/.ssh/authorized_keys file on the system they wish to connect to.

To log in to a device using the keys, a user can execute the following command:

```shell
ubuntu@focal-openssh-client:~$ ssh -i .ssh/id_ecdsa_sk 10.0.100.75
Confirm user presence for key ECDSA-SK
(...)
Welcome to Ubuntu Focal Fossa (development branch) (GNU/Linux 5.4.0-18-generic x86_64)
(...)
Last login: Mon Mar 30 20:29:05 2020 from 10.0.100.1
ubuntu@focal-openssh-server:~$
```

The prompt to confirm a user's presence will appear and wait until the user touches the second factor device.

At the time of writing this post, there is a problem with displaying the prompt when using GNOME. Please refer to the [Launchpad bug](https://bugs.launchpad.net/ubuntu/+source/gnome-shell/+bug/1869897) for more information about the expected fix date.

Download [Ubuntu 20.04 LTS (Focal Fossa)](https://ubuntu.com/download/server).
