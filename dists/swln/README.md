# SWLN - SWMB on your Local Network

SWLN (Local Network) is just a template to show you how to use and deploy SWMB on your network.
You can use SWMB differently from SWLN,
see for example the [Kaspersky uninstall](../uninstall-kaspersky/) project for workstations.

In order to have a fully functional SWMB,
we must place these files in the `C:\ProgramData\SWMB` tree.
```
CurrentUser-Logon.preset        -> Presets/
LocalMachine-Boot.preset        -> Presets/
LocalMachine-PostInstall.preset -> Presets/
Custom-VarOverload.psm1         -> Modules/
Local-Addon.psm1                -> Modules/
```

You can use a special preset that is applied once in the post-installation (`LocalMachine-PostInstall.preset`) of the software.
This can be useful for setting things that are the same and/or different from the PC boot process.
In some sites, there are only a few rules defined in the post-installation step because some PCs are not rebooted often.

The implementation of your rules (LocalMachine and CurrentUser) are written in the `Local-Addon.psm1` module
and you can define some parameters in the `Custom-VarOverload.psm1` module,
for example the IP of your time server if you use this tweak.

With this SWLN template you can easily create your packages under GNU/Linux or MacOS.
The core in the build process is a `Makefile` which uses the `curl` program to fetch the right version of SWMB.
The `Makefile` could have been written as a Bash script,
but `make` is a good program for building objects with dependencies.

In summary, you add your files to the SWLN folder (make a local copy at home),
then you type `make` and you will get a Zip which is easily deployed via the `install.bat` script inside the archive.
This procedure can be improved, but it is what we have been doing for years,
because it is more readable than a NullSoft installer and easier to use on UNIX machines.
