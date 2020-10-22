---
title: "Find Ubuntu Images on Microsoft Azure"
date: 2020-10-21
tags: ["ubuntu"]
draft: false
---

Canonical is the publisher of official Ubuntu images on Microsoft Azure. Users
can find the latest Ubuntu images in the Azure Marketplace when using the web
interface. For a programmatic interface, users can use Microsoft's
[Azure CLI](https://docs.microsoft.com/en-us/cli/azure/what-is-azure-cli). All
images published by Canonical are discoverable using the following command:

```shell
az vm image list --all --publisher Canonical
```

The output will produce JSON output with the following information for each
image:

```json
{
  "offer": "0001-com-ubuntu-server-focal",
  "publisher": "Canonical",
  "sku": "20_04-lts-gen2",
  "urn": "Canonical:0001-com-ubuntu-server-focal:20_04-lts-gen2:20.04.202010140",
  "version": "20.04.202010140"
}
```

Launching Azure instances via the Azure CLI is possible with the
[`az vm create`](https://docs.microsoft.com/en-us/cli/azure/vm?view=azure-cli-latest#az_vm_create)
command. The `--image` parameter is used to launch a specific image. The
parameter takes the `urn` value from the above output.

Using the above command lists every single image ever published by
Canonical on Azure. In order to find the latest, specific image type users
can filter based on the `sku` value. The `offer` value can change over time
and is not suggested for filtering.

Below is a breakdown of how to find each of the image types Canonical offers on
Azure.

## Release Images

On Microsoft Azure, Canonical produces a standard image for use with all
VM sizes, as well as an image that supports
[generation 2 virtual machines](https://docs.microsoft.com/en-us/azure/virtual-machines/generation-2).
Both image offerings are updated periodically with the latest Azure custom kernel,
security updates, and bug fixes.

Images produced for each release are searchable with the following SKUs, one SKU
for standard image and one for the gen2 image for each release:

```text
"20_04-lts"
"20_04-lts-gen2"
"18.04-lts"
"18_04-lts-gen2"
"16.04-lts"
"16_04-lts-gen2"
```

**NOTE**: The 18.04-lts and 16.04-lts SKUs were setup before a change in SKU
format. Going forward any new SKUs are not allowed to contain a period
charachter and will instead use an underscore. However, the previously
mentioned SKUs will continue to use the period.

The following is an example of how to find the latest image for Ubuntu 20.04
LTS:

```shell
$ az vm image list --all --publisher Canonical | \
    jq '[.[] | select(.sku=="20_04-lts")]| max_by(.version)'
{
  "offer": "0001-com-ubuntu-server-focal",
  "publisher": "Canonical",
  "sku": "20_04-lts",
  "urn": "Canonical:0001-com-ubuntu-server-focal:20_04-lts:20.04.202010140",
  "version": "20.04.202010140"
}
```

The target SKU string can be replaced with a different release or append `-gen2`
for generation 2 virtual machine images.

## Daily Images

Daily images are untested images that are generated whenever a package inside
the image changes in the Ubuntu archive. These images are meant for development
environments and testing. These images also include the development release of
Ubuntu.

Daily image SKUs have `-daily` added to the SKU and also offer the standard
and gen2 image for each release:

```text
"20_10-daily"
"20_10-daily-gen2"
"20_04-daily-lts"
"20_04-daily-lts-gen2"
"18.04-daily-lts"
"18_04-daily-lts-gen2"
"16.04-daily-lts"
"16_04-daily-lts-gen2"
```

**NOTE**: The 18.04-daily-lts and 16.04-daily-lts SKUs were setup before a
change in SKU format. Going forward any new SKUs are not allowed to contain a
period charachter and will instead use the underscore. However, the previously
mentioned SKUs will continue to use the period.

## Ubuntu Pro Images

[Ubuntu Pro for Azure](https://ubuntu.com/azure/pro) is a premium image offered
by Canonical containing access to additional security and compliance features.
Ubuntu Pro images are offered across all LTS releases:

* [Ubuntu 20.04 LTS (Focal)](https://azuremarketplace.microsoft.com/en-gb/marketplace/apps/canonical.0001-com-ubuntu-pro-focal?tab=Overview)
* [Ubuntu 18.04 LTS (Bionic)](https://azuremarketplace.microsoft.com/en-gb/marketplace/apps/canonical.0001-com-ubuntu-pro-bionic?tab=Overview)
* [Ubuntu 16.04 LTS (Xenial)](https://azuremarketplace.microsoft.com/en-gb/marketplace/apps/canonical.0001-com-ubuntu-pro-xenial?tab=Overview)
* [Ubuntu 14.04 LTS (Trusty)](https://azuremarketplace.microsoft.com/en-gb/marketplace/apps/canonical.0001-com-ubuntu-pro-trusty?tab=Overview)

The following SKUs make up the offerings for Ubuntu Pro for Azure:

```text
"pro-20_04-lts"
"pro-18_04-lts"
"pro-16_04-lts"
"pro-14_04-lts"
```

Here is an example, to find the latest Ubuntu 16.04 LTS Ubuntu Pro image:

```shell
$ az vm image list --all --publisher Canonical --sku "pro-16_04-lts" | \
    jq 'max_by(.version)'
{
  "offer": "0001-com-ubuntu-pro-xenial",
  "publisher": "Canonical",
  "sku": "pro-16_04-lts",
  "urn": "Canonical:0001-com-ubuntu-pro-xenial:pro-16_04-lts:16.04.20201014",
  "version": "16.04.20201014"
}
```

## Ubuntu Pro FIPS Images

Canonical also offers a FIPS specific image for
[Ubuntu 18.04 LTS](https://azuremarketplace.microsoft.com/en-gb/marketplace/apps/canonical.0001-com-ubuntu-pro-bionic-fips?tab=Overview)
and
[Ubuntu 16.04 LTS](https://azuremarketplace.microsoft.com/en-gb/marketplace/apps/canonical.0001-com-ubuntu-pro-xenial-fips?tab=Overview).
These FIPS images use the following SKUs:

```text
"pro-fips-18_04"
"pro-fips-16_04-private"
```

And below is an example to find the latest Ubuntu Pro FIPS image for Ubuntu
18.04 LTS:

```shell
$ az vm image list --all --publisher Canonical --sku "pro-fips-18_04" | \
    jq 'max_by(.version)'
{
  "offer": "0001-com-ubuntu-pro-bionic-fips",
  "publisher": "Canonical",
  "sku": "pro-fips-18_04",
  "urn": "Canonical:0001-com-ubuntu-pro-bionic-fips:pro-fips-18_04:18.04.202010201",
  "version": "18.04.202010201"
}
```
