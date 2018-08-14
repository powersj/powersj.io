---
title: "Ubuntu Bionic: nVidia CUDA Setup"
date: 2018-08-14
tags: ["ubuntu", "server", "nvidia"]
draft: false
---

In a previous post, I described how to setup a system with nVidia's CUDA software with Ubuntu 16.04 LTS. With the recent release of Ubuntu 18.04 LTS, Bionic Beaver, I wanted to update that post for the new LTS release.

# nVidia Package Archive

As of today, the [nVidia repo](https://developer.download.nvidia.com/compute/cuda/repos/) does not have software packages for the Bionic release. At some point in the near future, an 18.04 entry will appear and have the software. I can update this post when that happens.

# Ubuntu Package Archive

However, until the nVidia archive is updated, the best method is to install directly from the Ubuntu Bionic repo:

```shell
$ sudo apt update
$ sudo apt install -y nvidia-headless-390 nvidia-utils-390 nvidia-cuda-toolkit
```

After rebooting the system the user can then verify that CUDA is setup correctly by verifying the devices show up and nvidia-smi output.

Below is an example from an [AWS p3.16xlarge](https://aws.amazon.com/ec2/instance-types/p3/) system with 8 Tesla V100s:

```shell
$ ls /dev/nvidia*
/dev/nvidia-uvm  /dev/nvidia1  /dev/nvidia3  /dev/nvidia5  /dev/nvidia7
/dev/nvidia0     /dev/nvidia2  /dev/nvidia4  /dev/nvidia6  /dev/nvidiactl
$ nvidia-smi
Tue Aug 14 20:45:19 2018
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 390.48                 Driver Version: 390.48                    |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  Tesla V100-SXM2...  Off  | 00000000:00:17.0 Off |                    0 |
| N/A   41C    P0    39W / 300W |      0MiB / 16160MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
|   1  Tesla V100-SXM2...  Off  | 00000000:00:18.0 Off |                    0 |
| N/A   39C    P0    38W / 300W |      0MiB / 16160MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
|   2  Tesla V100-SXM2...  Off  | 00000000:00:19.0 Off |                    0 |
| N/A   38C    P0    37W / 300W |      0MiB / 16160MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
|   3  Tesla V100-SXM2...  Off  | 00000000:00:1A.0 Off |                    0 |
| N/A   39C    P0    38W / 300W |      0MiB / 16160MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
|   4  Tesla V100-SXM2...  Off  | 00000000:00:1B.0 Off |                    0 |
| N/A   42C    P0    40W / 300W |      0MiB / 16160MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
|   5  Tesla V100-SXM2...  Off  | 00000000:00:1C.0 Off |                    0 |
| N/A   40C    P0    38W / 300W |      0MiB / 16160MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
|   6  Tesla V100-SXM2...  Off  | 00000000:00:1D.0 Off |                    0 |
| N/A   42C    P0    41W / 300W |      0MiB / 16160MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
|   7  Tesla V100-SXM2...  Off  | 00000000:00:1E.0 Off |                    0 |
| N/A   41C    P0    40W / 300W |      0MiB / 16160MiB |      3%      Default |
+-------------------------------+----------------------+----------------------+

+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID   Type   Process name                             Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+
```
