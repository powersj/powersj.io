---
title: "Update ThinkPad X1 Firmware with Ubuntu"
date: 2019-05-31
tags: ["battlestation"]
draft: true
---

Recent security announcements have made the need to be running the latest firmware more important than ever. One thing that frustrated me about running Linux was when I needed to do BIOS upgrades it always seemed like a hassle to correctly setup a USB key and then boot into it. There has to be an easier way:

Enter the `fwupdate` package!

TODO: explain what this is, how it works
TODO: fwupdate vs fwupdmgr

## New Firmware

At the end of 2018, I bought myself a new ThinkPad X1 Carbon. I had a 3rd generation one and made the jump up to a new shiny 6th generation.

TODO: product number on back of system
TODO: download page on lenovo.com
TODO: extract devices

## Updating

Once the package is obtained and decompressed, updating is as easy as the following:

```shell
$ sudo fwupdmgr install n23et62w.cab
Decompressing…           [***************************************]
Authenticating…          [***************************************]
Installing on 20KHCTO1WW System Firmware…                        ]
Scheduling…              [***************************************]

An update requires a reboot to complete. Restart now? [Y|n]:
```

During the reboot the system will preform the upgrade and it may even reboot a couple times.

## Verification

After booting back into Ubuntu, check out dmesg messages for the BIOS to verify the new version was successfully upgraded to:

```shell
[    0.000000] DMI: LENOVO 20KHCTO1WW/20KHCTO1WW, BIOS N23ET62W (1.37 ) 02/19/2019
[   16.152940] thinkpad_acpi: ThinkPad BIOS N23ET62W (1.37 ), EC unknown
```

## Conclusion

Having the latest firmware can be helpful for security reasons and having an even easier mechanism to use to do that upgrade gives no excuse to not upgrade.
