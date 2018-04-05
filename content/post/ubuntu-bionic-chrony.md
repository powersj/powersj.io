---
title: "Ubuntu Bionic: Using chrony to configure NTP"
date: 2018-04-09
tags: ["ubuntu", "bionic", "chrony"]
draft: false
---

# Using chrony to configure NTP

Starting with [Ubuntu Bionic](https://wiki.ubuntu.com/BionicBeaver/ReleaseNotes), [chrony](https://chrony.tuxfamily.org/index.html) will be used for fast and accurate time synchronization. If you are interested in how chrony compares to other implementations check out the [comparison](https://chrony.tuxfamily.org/comparison.html) page.

This post will demonstrate how to get started with chrony and a few of the common commands that end-users will find helpful.

## Getting Started

If chrony is not already installed it is a simple apt install away:

```shell
sudo apt install chrony
```

The package consists of two commands: `chronyc` the client and `chronyd` the daemon. To verify that chrony is successfully installed and the time is now synced check out the `activity` command:

```shell
$ chronyc activity
200 OK
8 sources online
0 sources offline
0 sources doing burst (return to online)
0 sources doing burst (return to offline)
0 sources with unknown address
```

At this point, most users may be happy with chrony running quickly and accurately synchronizing their system time.

### Configuration

Configuration of chrony occurs in the `/etc/chrony/chrony.conf` file. For details on all the various arguments see the [configuration file](https://chrony.tuxfamily.org/manual.html#Configuration-file) page on the chrony site.

By default, the Ubuntu package will come with the configuration file pointing at `ntp.ubuntu.com` and the `ubuntu.pool.ntp.org` as ntp servers to provide 6 dual-stack NTP sources and 2 additional IPv4-only sources.

The only other item to note is the default configuration is the makestep argument, which will step up the system clock if the adjustment is larger than 1 second, but only for the first three clock updates. All other adjustments will use clock skewing to gradually correct the time by speeding up or slowing down the clock.

### Commands

Here a few other commands to know when using chrony. A user can run these commands with chronyc or use chronyc to pull up a chrony specific command prompt and run them there.

#### tracking

To check if chrony is tracking with a server and to learn which one view the `tracking` command output:

```shell
$ chronyc tracking
Reference ID    : AB42617E (srcf-ntp.stanford.edu)
Stratum         : 2
Ref time (UTC)  : Thu Apr 05 18:27:33 2018
System time     : 0.000669840 seconds slow of NTP time
Last offset     : -0.000506939 seconds
RMS offset      : 0.001261410 seconds
Frequency       : 28.552 ppm slow
Residual freq   : -0.000 ppm
Skew            : 88.846 ppm
Root delay      : 0.031207338 seconds
Root dispersion : 0.001206590 seconds
Update interval : 65.2 seconds
Leap status     : Normal
```

#### sources

The `sources` command shows a list of servers used and last sample time. I highly suggest using the `-v` flag to get more details on each column meanings. Users should pay attention for servers with a state of '?', 'x', or '~'.

```shell
$ chronyc sources -v
210 Number of sources = 8

  .-- Source mode  '^' = server, '=' = peer, '#' = local clock.
 / .- Source state '*' = current synced, '+' = combined , '-' = not combined,
| /   '?' = unreachable, 'x' = time may be in error, '~' = time too variable.
||                                                 .- xxxx [ yyyy ] +/- zzzz
||      Reachability register (octal) -.           |  xxxx = adjusted offset,
||      Log2(Polling interval) --.      |          |  yyyy = measured offset,
||                                \     |          |  zzzz = estimated error.
||                                 |    |           \
MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================================
^+ chilipepper.canonical.com     2   7   377    39  +1245us[+1245us] +/-  102ms
^+ pugot.canonical.com           2   6   377    37   -554us[ -554us] +/-   99ms
^+ golem.canonical.com           2   6   377    39  -1135us[-1135us] +/-   98ms
^+ alphyn.canonical.com          2   6   377    44    -87us[  +62us] +/-   74ms
^* clock.xmission.com            2   6   377    41  -4641ns[ +144us] +/-   41ms
^+ duffman.whackertech.com       2   6   377    40    -14ms[  -14ms] +/-   89ms
^+ palpatine.steven-mcdonal>     2   6   177    40  +2565us[+2565us] +/-   46ms
^+ paladin.latt.net              2   7   377   106   -746us[ -573us] +/-   41ms
```

#### sourcestats

The `sourcestats` command is used to show additional statistics for each server. Again, I highly suggest using the `-v` flag to get more details on each column.

```shell
$ chronyc sourcestats -v
210 Number of sources = 8
                             .- Number of sample points in measurement set.
                            /    .- Number of residual runs with same sign.
                           |    /    .- Length of measurement set (time).
                           |   |    /      .- Est. clock freq error (ppm).
                           |   |   |      /           .- Est. error in freq.
                           |   |   |     |           /         .- Est. offset.
                           |   |   |     |          |          |   On the -.
                           |   |   |     |          |          |   samples. \
                           |   |   |     |          |          |             |
Name/IP Address            NP  NR  Span  Frequency  Freq Skew  Offset  Std Dev
==============================================================================
chilipepper.canonical.com  19   9  1170     +1.015      2.938   +166us  1095us
pugot.canonical.com         7   4   456     -0.639     11.812  +1362us   710us
golem.canonical.com         9   4   519     -0.315      7.244  +1891us   693us
alphyn.canonical.com        9   4   518     -0.919      9.460  +1134us   880us
clock.xmission.com          6   3   390     -1.257     20.127  +1978us   823us
duffman.whackertech.com     6   3   323     +2.404     25.543    -13ms   680us
palpatine.steven-mcdonal>   7   3   390     -0.421     15.058  +1776us   742us
paladin.latt.net           21  14   20m     +1.002      2.846  +1085us  1373us
```

## Local Server

If you have multiple systems on a network it is [advisable to setup a single system](https://chrony.tuxfamily.org/faq.html#_i_have_several_computers_on_a_lan_should_be_all_clients_of_an_external_server) to act as the server for all other local systems. This is similar to how cloud providers will run their own NTP servers for instances inside their data centers. As stated on the chrony site, the benefits of this model include reduced load on external connections, reduced load on the remote ntp server, and keeps local systems in sync with each other should the external connection or servers go down.

To enable a local server in the configuration file, specify the network and subnet to allow connections from. For example, the below lines would allow connections from 192.168.2.0/24 and all of the 10.0.0.0/8 subnet:

```conf
allow 192.168.2
allow 10.0.0.0/8
```

Assuming port 123 is open for connections and the service is restarted local systems should then be able to connect.

On the clients, then update the chrony configuration to point at the new system and restart chrony. For example, my server is at 192.168.2.12 I can update the configuration file to use it to synchronize by adding:

```conf
pool 192.168.2.12 iburst
```

And then verify the service is up with the one server using `cronyc activity` and the status of the server and connection using the `cronyc tracking` command.

On the server, you can verify clients using the `clients` command:

```shell
$ sudo chronyc clients
Hostname                      NTP   Drop Int IntL Last     Cmd   Drop Int  Last
===============================================================================
viper.maas                    390      0   0   -     0       0      0   -     -
localhost                       0      0   -   -     -       1      0   -     2
```

Access can be tested using the `accheck <address>` command.

## Hardware Timestamping

To enable even more accurate time synchronization consider using [hardware timestamping](https://chrony.tuxfamily.org/doc/3.3/chrony.conf.html#hwtimestamp) if you are hardware supports it. This features provides incoming and outgoing packets with precise timestamps using the network controller. If this feature is enabled, it is best to enable it on both the host and clients.

### Hardware Support

To determine if your hardware supports this feature use ethtool. To verify support of timestamping look for ***ALL*** of the following capabilities:

- SOF_TIMESTAMPING_RAW_HARDWARE
- SOF_TIMESTAMPING_TX_HARDWARE
- SOF_TIMESTAMPING_RX_HARDWARE

And the NIC must have ***EITHER*** of the following capabilities (at least one):

- HWTSTAMP_FILTER_ALL
- HWTSTAMP_FILTER_NTP_ALL

Here is an example of a NIC that has all the necessary capabilities for both send and receive:

```shell
$ ethtool -T enp0s25
Time stamping parameters for enp0s25:
Capabilities:
    hardware-transmit     (SOF_TIMESTAMPING_TX_HARDWARE)
    software-transmit     (SOF_TIMESTAMPING_TX_SOFTWARE)
    hardware-receive      (SOF_TIMESTAMPING_RX_HARDWARE)
    software-receive      (SOF_TIMESTAMPING_RX_SOFTWARE)
    software-system-clock (SOF_TIMESTAMPING_SOFTWARE)
    hardware-raw-clock    (SOF_TIMESTAMPING_RAW_HARDWARE)
PTP Hardware Clock: 0
Hardware Transmit Timestamp Modes:
    off                   (HWTSTAMP_TX_OFF)
    on                    (HWTSTAMP_TX_ON)
Hardware Receive Filter Modes:
    none                  (HWTSTAMP_FILTER_NONE)
    all                   (HWTSTAMP_FILTER_ALL)
    ptpv1-l4-sync         (HWTSTAMP_FILTER_PTP_V1_L4_SYNC)
    ptpv1-l4-delay-req    (HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ)
    ptpv2-l4-sync         (HWTSTAMP_FILTER_PTP_V2_L4_SYNC)
    ptpv2-l4-delay-req    (HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ)
    ptpv2-l2-sync         (HWTSTAMP_FILTER_PTP_V2_L2_SYNC)
    ptpv2-l2-delay-req    (HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ)
    ptpv2-event           (HWTSTAMP_FILTER_PTP_V2_EVENT)
    ptpv2-sync            (HWTSTAMP_FILTER_PTP_V2_SYNC)
    ptpv2-delay-req       (HWTSTAMP_FILTER_PTP_V2_DELAY_REQ)
```

For more details on these capabilities see the [kernel timestamping](https://www.kernel.org/doc/Documentation/networking/timestamping.txt) documentation.

### Enable Hardware Timestamping

To enable hardware timestamping in the configuration add the `hwtimestamp` option and either specify a single interface or use the wildcard character (*) to enable hardware timestamping on all interfaces that support it:

```conf
hwtimestamp eth0
hwtimestamp *
```

Once the service is restarted a user can verify if hardware timestamping is used by a particular interface through messages in syslog:

```syslog
Apr  5 21:09:31 nexus chronyd[4104]: Enabled HW timestamping on enp0s25
```

And finally, verify using the client as well:

```shell
$ sudo chronyc ntpdata 192.168.2.12 | grep timestamping
TX timestamping : Hardware
RX timestamping : Hardware
```

### Additional Performance

Per the chrony guide on [improving accuracy](https://chrony.tuxfamily.org/faq.html#_how_can_i_improve_the_accuracy_of_the_system_clock_with_ntp_sources), when connecting to a local system it is suggested to also change the polling interval and to use the interleave mode for additional performance gains:

```conf
server 192.168.2.12 minpoll 0 maxpoll 0 xleave
```

## Authentication

To secure chornyc commands and NTP packets a user can enable authentication.

Keys are stored in the `/etc/chrony/chrony.keys` file (as setup by the chrony.conf file) and the file can take a [variety of hash functions](https://chrony.tuxfamily.org/doc/3.3/chrony.conf.html#keyfile).

### keygen

The built in [keygen](https://chrony.tuxfamily.org/doc/3.3/chronyc.html#keygen) command can be used to generate random keys. It takes the following optional arguments:

1. The key ID (Default: 1)
1. The type of has function to use (Default: SHA1 or MD5 if SHA1 is not available)
1. The number of bits to use between 80 and 4096 (Default: 160)

Here are examples:

```shell
# id 1 with a 160-bit SHA1 key
$ chronyc keygen
1 SHA1 HEX:57545218761536EE5FCBCEF67D9F720DE462FB4B
# id 3 with a 160-bit SHA1 key
$ chronyc keygen 3 SHA1
3 SHA1 HEX:C47254E85E4FBE1FD2D01FE3BFEA742B32CFB5A2
# id 16 with a 128-bit SHA256key
$ chronyc keygen 16 SHA256 128
16 SHA256 HEX:9001F203D6333523E320864C04259B20
# id 27 with a 512-bit SHA512
$ chronyc keygen 27 SHA512 512
27 SHA512 HEX:B08BAAB8DED064D2C2351ED8C9EE5AABE784C80482809C5329187A2BE9D80A0B1E6E18C4164946F6D8E36F1C4A2A966B3B754B1FDE89A0E66FE92CC1E65364E5
```

### Example Authentication

First, the key files of the server and the client need the same key ID entry as the client, otherwise no relationship between the computers will be possible. The server needs to be restarted for the key to take effect.

For example, if the client and server key files had the following entry:

```conf
27 SHA1 HEX:57545218761536EE5FCBCEF67D9F720DE462FB4B
```

On the client, in order to tell Chrony to use key #27 for a particular server add the key option to the cooresponding server entry:

```conf
add server 192.168.1.12 key 27
```

Restart the service and see if the server now shows as authenticated:

```shell
$ sudo chronyc ntpdata 192.168.2.12 | grep Authenticated
Authenticated   : Yes
```

## Debugging

### Status

To determine the synchronizing status, check the values from the tracking command. If the values are all zeros and the reference time is wrong, then the system is not synchronizing correctly. For example an end user would see the following output:

```shell
$ chronyc tracking
Reference ID    : 00000000 ()
Stratum         : 0
Ref time (UTC)  : Thu Jan 01 00:00:00 1970
System time     : 0.000000000 seconds fast of NTP time
Last offset     : +0.000000000 seconds
RMS offset      : 0.000000000 seconds
Frequency       : 0.888 ppm fast
Residual freq   : +0.000 ppm
Skew            : 0.000 ppm
Root delay      : 1.000000000 seconds
Root dispersion : 1.000000000 seconds
Update interval : 0.0 seconds
Leap status     : Not synchronised
```

If output like the above is seen, then checking the connectivity to the defined server or pool would is advised.

### Logs

By default logs for chrony go to syslog, therefore start by looking through `/var/log/syslog` for the debugging.

#### Additional Logging

If even more logging is required aid in debugging or tracking of your NTP service, it is possible by uncommenting or adding the line below to the chrony configuration file. This will log additional data and statistics.

```conf
# Uncomment the following line to turn additional logging on
log measurements statistics tracking
# or for even more logs add additional items
log measurements statistics tracking rtc refclocks tempcomp
```

These logs will appear under the default directory of `/var/log/chrony`

```shell
$ ls /var/log/chrony/
measurements.log  statistics.log  tracking.log
```

# Resources

- [chrony webpage](https://chrony.tuxfamily.org/index.html)
- [chrony faq](https://chrony.tuxfamily.org/faq.html)
- [chrony docs](https://chrony.tuxfamily.org/documentation.html)
- [help and support](https://ubuntuforums.org/forumdisplay.php?f=339)
- [file a bug](https://bugs.launchpad.net/ubuntu/+source/chrony/+filebug)
