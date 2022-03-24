# SWMB - Secure Windows Mode Batch

## General

source: [https://resinfo-gt.pages.in2p3.fr/swmb/resinfo-swmb/](https://resinfo-gt.pages.in2p3.fr/swmb/resinfo-swmb/)

maintainer: <Gabriel.Moreau at legi.grenoble-inp.fr>

date: __DATE__

description: see the main [README](https://resinfo-gt.pages.in2p3.fr/swmb/resinfo-swmb/README.md) web page


## Usage

Example of simple use under GNU/Linux.

1. Push the package on your WAPT server:
   ```bash
   # download
   wget --no-check-certificate --timestamping https://resinfo-gt.pages.in2p3.fr/swmb/resinfo-swmb/SWMB-WAPT-Latest.zip

   # unzip
   unzip SWMB-WAPT-Latest.zip

   # push on wapt server
   wapt-get build-upload swmb
   ```

2. Now, SWMB package can be deployed on users' computers.

   You need to push your own presets via another package (or any other method) in order to have a security policy on your workstations.
   By default, SWMB doesn't do anything dangerous, it's just a security framework.
   You are always in control of your computer park.
