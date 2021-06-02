# FAQ

**Q:** Can I run the script safely?  
**A:** Definitely not. You have to understand what the functions do and what will be the implications for you if you run them.
Some functions lower security, hide controls or uninstall applications. **If you're not sure what the script does, do not attempt to run it!**

**Q:** Can I run the script repeatedly?  
**A:** Yes! In fact the script has been written to support exactly that, as it's not uncommon that big Windows Updates reset some of the settings.

**Q:** Which versions and editions of Windows are supported?  
**A:** The script aims to be fully compatible with the most up-to-date 64bit version of Windows 10 receiving updates from semi-annual channel,
however if you create your own preset and exclude the incompatible tweaks, it will work also on LTSB/LTSC and possibly also on 32bit systems.
Vast majority of the tweaks will work on all Windows editions.
Some of them rely on group policy settings, so there may be a few limitations for Home and Education editions.

**Q:** Can I run the script on Windows Server 2016 or 2019?  
**A:** Yes. Starting from version 2.5, Windows Server is supported.
There are even few tweaks specific to Server environment.
Keep in mind though, that the script is still primarily designed for Windows 10, so you have to create your own preset.

**Q:** Can I run the script on Windows 7, 8, 8.1 or other versions of Windows?  
**A:** No. Although some tweaks may work also on older versions of Windows, the script is developed only for Windows 10 and Windows Server 2016 / 2019.
There are no plans to support older versions.

**Q:** Can I run the script in multi-user environment?  
**A:** Yes, to certain extent. Some tweaks (most notably UI tweaks) are set only for the user currently executing the script.
As stated above, the script can be run repeatedly; therefore it's possible to run it multiple times, each time as different user.
Due to the nature of authentication and privilege escalation mechanisms in Windows,
most of the tweaks can be successfully applied only by users belonging to *Administrators* group.
Standard users will get an UAC prompt asking for admin credentials which then causes the tweaks to be applied to the given admin account
instead of the original non-privileged one.
There are a few ways how this can be circumvented programmatically,
but I'm not planning to include any as it would negatively impact code complexity and readability.
If you still wish to try to use the script in multi-user environment,
check [this answer in issue #29](https://github.com/Disassembler0/Win10-Initial-Setup-Script/issues/29#issuecomment-333040591) for some pointers.

**Q:** Did you test the script?  
**A:** Yes. I'm testing new additions on up-to-date 64bit Home and Enterprise editions in VMs.
I'm also regularly using it for all my home installations after all bigger updates.

**Q:** I've run the script and it did something I don't like, how can I undo it?  
**A:** For every tweak, there is also a corresponding function which restores the default settings.
The default is considered freshly installed Windows 10 or Windows Server 2016 with no adjustments made during or after the installation.
Use the tweaks to create and run new preset.
Alternatively, since some functions are just automation for actions which can be done using GUI, find appropriate control and modify it manually.

**Q:** I've run the script and some controls are now greyed out and display message "*Some settings are hidden or managed by your organization*", why?  
**A:** To ensure that system-wide tweaks are applied smoothly and reliably, some of them make use of *Group Policy Objects* (*GPO*).
The same mechanism is employed also in companies managing their computers in large scale, so the users without administrative privileges can't change the settings.
If you wish to change a setting locked by GPO, apply the appropriate restore tweak and the control will become available again.

**Q:** I've run the script and it broke my computer / killed neighbor's dog / caused world war 3.  
**A:** I don't care. Also, that's not a question.

**Q:** I'm using a tweak for &lt;feature&gt; on my installation, can you add it?  
**A:** Submit a PR, create a feature request issue or drop me a message.
If I find the functionality simple, useful and not dependent on any 3rd party modules or executables (including also *Chocolatey*,
*NuGet*, *Ninite* or other automation solutions), I might add it.

**Q:** Can I use the script or modify it for my / my company's needs?  
**A:** Sure, knock yourself out. Just don't forget to include copyright notice as per MIT license requirements.
I'd also suggest including a link to this GitHub repo as it's very likely that something will be changed,
added or improved to keep track with future versions of Windows 10.

**Q:** Why are there repeated pieces of code throughout some functions?  
**A:** So you can directly take a function block or a line from within a function and use it elsewhere, without elaborating on any dependencies.

**Q:** For how long are you going to maintain the script?  
**A:** As long as somebody in the ESR use SWMB to configure Windows 10.
