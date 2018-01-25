---
title: "nVidia CUDA on Ubuntu Server"
date: 2017-11-03
tags: ["ubuntu", "server", "nvidia"]
draft: false
---

In my previous post about [etherium mining on Ubuntu]({{< ref "ubuntu-etherium-nvidia.md" >}}) I ended by stating I wanted to look at what it would take to get nVidia's CUDA drivers. Use of the CUDA drivers unlocks even further performance from my nVidia GTX 1070 graphics card in certain applications and specifically can demonstrate improvements while doing etherium mining.

This post will demonstrate two methods of install for the CUDA drivers:

1. Ubuntu package archive
1. nVidia package archive

# Ubuntu Package Archive

Install from the archive is extremely simple and quick. All that is required is to install the nvidia-cuda-toolkit package and it will also get all the required CUDA libraries and tools:

```shell
sudo apt update
sudo apt install nvidia-cuda-toolkit
sudo shutdown -r now
```

After rebooting, to verify that CUDA drivers are installed there are three ways to check that everything is up and running:

1. Check that the nvidia* device files exist in /dev
1. Use the nvcc command to show what version of the driver is installed
1. Run nvidia-smi to get detailed version about the device like power and fan info, processes using the GPU, and driver versions.

Example output of all three is below:

```shell
$ ls /dev/nvidia*
/dev/nvidia0  /dev/nvidiactl /dev/nvidia-uvm
$ nvcc -V
nvcc: NVIDIA (R) Cuda compiler driver
Copyright (c) 2005-2015 NVIDIA Corporation
Built on Tue_Aug_11_14:27:32_CDT_2015
Cuda compilation tools, release 7.5, V7.5.17
$ nvidia-smi
Sat Oct 28 14:17:15 2017
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 384.90                 Driver Version: 384.90                    |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  GeForce GTX 1070    Off  | 00000000:01:00.0  On |                  N/A |
|  0%   49C    P8    11W / 185W |     99MiB /  8110MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+

+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID   Type   Process name                             Usage      |
|=============================================================================|
|    0      1170      G   /usr/lib/xorg/Xorg                            97MiB |
+-----------------------------------------------------------------------------+
```

# nVidia Package Archive

This section will look to downloading the library directly from nVidia itself in order to get the latest version of the package. The nVidia repo also contains a [variety of meta packages](http://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#package-manager-metas) allowing an end-user to limit the install to the libraries, runtime, or the toolkits that are needed versus installing everything.

nVidia runs a [repo](https://developer.download.nvidia.com/compute/cuda/repos/) which can be added to apt and then install directly from. Using this repo means the install will stay up-to-date. I will use the cuda metapackage, which will install all CUDA toolkit and driver packages and upgrade both as new versions are released:

```shell
echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/ /" | sudo tee /etc/apt/sources.list.d/cuda.list
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
sudo apt update
sudo apt install cuda
sudo shutdown -r now
```

The final step, which is required is to modify your path to point at the binaries:

```shell
export PATH=/usr/local/cuda-9.0/bin${PATH:+:${PATH}}
```

# Test CUDA

Similar to installs from the archive below is output from /dev, nvcc, and nvidia-smi:

```shell
$ ls /dev/nvidia*
/dev/nvidia0  /dev/nvidiactl  /dev/nvidia-modeset  /dev/nvidia-uvm  /dev/nvidia-uvm-tools
$ nvcc -V
nvcc: NVIDIA (R) Cuda compiler driver
Copyright (c) 2005-2017 NVIDIA Corporation
Built on Fri_Sep__1_21:08:03_CDT_2017
Cuda compilation tools, release 9.0, V9.0.176
$ nvidia-smi
Sat Oct 28 15:57:59 2017
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 384.90                 Driver Version: 384.90                    |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  GeForce GTX 1070    Off  | 00000000:01:00.0  On |                  N/A |
|  0%   41C    P8    10W / 185W |    121MiB /  8110MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+

+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID   Type   Process name                             Usage      |
|=============================================================================|
|    0      1181      G   /usr/lib/xorg/Xorg                           119MiB |
+-----------------------------------------------------------------------------+
```

Additionally, the package comes with some additional scripts that are interesting to play with, found under `/usr/local/cuda/extras/demo_suite`.

# Device Query

```shell
$ /usr/local/cuda/extras/demo_suite/deviceQuery
./deviceQuery Starting...

 CUDA Device Query (Runtime API) version (CUDART static linking)

Detected 1 CUDA Capable device(s)

Device 0: "GeForce GTX 1070"
  CUDA Driver Version / Runtime Version          9.0 / 9.0
  CUDA Capability Major/Minor version number:    6.1
  Total amount of global memory:                 8111 MBytes (8504868864 bytes)
  (15) Multiprocessors, (128) CUDA Cores/MP:     1920 CUDA Cores
  GPU Max Clock rate:                            1797 MHz (1.80 GHz)
  Memory Clock rate:                             4004 Mhz
  Memory Bus Width:                              256-bit
  L2 Cache Size:                                 2097152 bytes
  Maximum Texture Dimension Size (x,y,z)         1D=(131072), 2D=(131072, 65536), 3D=(16384, 16384, 16384)
  Maximum Layered 1D Texture Size, (num) layers  1D=(32768), 2048 layers
  Maximum Layered 2D Texture Size, (num) layers  2D=(32768, 32768), 2048 layers
  Total amount of constant memory:               65536 bytes
  Total amount of shared memory per block:       49152 bytes
  Total number of registers available per block: 65536
  Warp size:                                     32
  Maximum number of threads per multiprocessor:  2048
  Maximum number of threads per block:           1024
  Max dimension size of a thread block (x,y,z): (1024, 1024, 64)
  Max dimension size of a grid size    (x,y,z): (2147483647, 65535, 65535)
  Maximum memory pitch:                          2147483647 bytes
  Texture alignment:                             512 bytes
  Concurrent copy and kernel execution:          Yes with 2 copy engine(s)
  Run time limit on kernels:                     Yes
  Integrated GPU sharing Host Memory:            No
  Support host page-locked memory mapping:       Yes
  Alignment requirement for Surfaces:            Yes
  Device has ECC support:                        Disabled
  Device supports Unified Addressing (UVA):      Yes
  Supports Cooperative Kernel Launch:            Yes
  Supports MultiDevice Co-op Kernel Launch:      Yes
  Device PCI Domain ID / Bus ID / location ID:   0 / 1 / 0
  Compute Mode:
     < Default (multiple host threads can use ::cudaSetDevice() with device simultaneously) >

deviceQuery, CUDA Driver = CUDART, CUDA Driver Version = 9.0, CUDA Runtime Version = 9.0, NumDevs = 1
Result = PASS
```

# Bandwidth Test

```shell
$ /usr/local/cuda/extras/demo_suite/bandwidthTest
[CUDA Bandwidth Test] - Starting...
Running on...

 Device 0: GeForce GTX 1070
 Quick Mode

 Host to Device Bandwidth, 1 Device(s)
 PINNED Memory Transfers
   Transfer Size (Bytes)    Bandwidth(MB/s)
   33554432         12665.1

 Device to Host Bandwidth, 1 Device(s)
 PINNED Memory Transfers
   Transfer Size (Bytes)    Bandwidth(MB/s)
   33554432         12916.1

 Device to Device Bandwidth, 1 Device(s)
 PINNED Memory Transfers
   Transfer Size (Bytes)    Bandwidth(MB/s)
   33554432         190526.5

Result = PASS

NOTE: The CUDA Samples are not meant for performance measurements. Results may vary when GPU Boost is enabled.
```

# Refrences

* [nVidia CUDA Documentation](http://docs.nvidia.com/cuda/index.html)
* [nVidia CUDA Linux Install Guide](http://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html)
* [How to do LXD GPU Passthrough](https://insights.ubuntu.com/2017/03/28/nvidia-cuda-inside-a-lxd-container/)
