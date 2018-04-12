# CCS Release: Hue Bridge 2.0, version 1802201122

This package includes the Complete Corresponding Machine-readable Source Code as defined in the GPLv2 for the Hue Bridge 2.0.

The following is included:

1. All the source code for open-source licensed modules in the product.
2. All associated interface definition files.
3. The scripts used to compile compilation.
4. The scripts (instructions) used to install the resulting executables.

## Cryptographic lock-down

The Hue Bridge 2.0 is cryptographically locked down. We would have loved to ship a fully hackable device, but certification requirements can sometimes get in the way. We can therefore not provide you with usable installation instructions that will not void the waranty on your Hue Bridge 2.0. 

## Compilation

### Prerequisites

To build the CCS, you need the following:

1. Linux distribution: Ubuntu 16.04.4 LTS
2. Required executables: gcc g++ objcopy patch bzip2 flex make xgettext pkg-config unzip svn gawk ocamlyacc cmake hg ocamlfind repo ubireader_extract_images unsquashfs openssl firejail srec_cat curl python3 pip3 pip3 mkdir repo git grep mkenvimage unix2dos
3. Required debian packages: libunwind8-dev libssl-dev python3-lxml zlib1g-dev liblzo2-dev
4. Required Python packages (installed with pip): yaml magic openpyxl git xmlrunner lzo

Notes:

* The required executables is not an exaustive list. It should however cover at least the non-default packages for Ubuntu 16.04.4 LTS.
* If you try to call any missing executables on the command-line, Ubuntu 16.04.4 LTS should suggest the missing package.

### Steps

1. From the directory containing this README.md file, simply run:```make```
2. The output images (and contained executables) are copied to `bridge/build/bsb002/release/product/factory/bsb002`

## Installation

WARNING: The installation instructions will void your warranty. If you are not careful, you might also permanently damage your Hue Bridge 2.0.

### Prerequisites

You will need the following:

1. A PCB solder and rework station.
2. A flash programmer capable of programming the following:
  * A GigaDevice GD25Q41BTIGR 3.3V SPI NOR flash part
  * A GigaDevice GD5F1GQ4UCYIG 3.3V SPI NAND flash part

### Steps

To install the images (and contained executables) to the Hue Bridge 2.0, follow these steps:

1. Open your bridge by removing the screws under the rubber feet.
2. De-solder parts SU9 and SU11 from the PCB, being careful not to damage the pads on the PCB or the parts.
3. Set-up the programmer to correctly program a GigaDevice GD25Q41BTIGR 3.3V SPI NOR flash part.
4. Install SU11 into the flash programmer.
5. Erase address range 0x0 - 0x40000 within SU11, being careful not to erase anything else.
6. Flash `bridge/build/bsb002/release/product/factory/bsb002/bsb002_uboot.bin` into SU11 at offset 0x0.
7. Remove SU11 from the programmer.
8. Set-up the programmer to correctly program a GigaDevice GD5F1GQ4UCYIG 3.3V SPI NAND flash part:
  * Configure erase blocks marked bad to be skipped when erasing.
  * Configure erase blocks marked bad to be skipped when programming.
9. Install SU9 into the flash programmer.
10. Erase the entire SU9 device, but do not reset bad block markers.
11. Flash `bridge/build/bsb002/release/product/factory/bsb002/kernel.bin` into SU9 at both offset 0x0 and 0x2C00000
12. Flash `bridge/build/bsb002/release/product/factory/bsb002/root.bin` into SU9 at both offset 0x400000 and 0x3000000.
13. Flash `bridge/build/bsb002/release/product/factory/bsb002/overlay.bin` into SU9 at offset 0x5800000.
14. Remove SU9 from the programmer.
15. Re-solder parts SU9 and SU11 onto the PCB, being careful not to damage the pads on the PCB or the parts.
