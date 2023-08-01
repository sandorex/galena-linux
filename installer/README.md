## Galena Installer
Small-ish (~1.5gb at the moment) installer image to install debian stable, with few tools preinstalled and XFCE4 desktop

At the moment it is only a live image installer with rescue tooling preinstalled, but there are many planned features:
- Automatic btrfs partition layout compatible with timeshift
- Automatic rescue image installation (uses `grub-imageboot` and rescue ISO)
- Additional "editions" with minimal desktop environment with basic set of tools mimicking what windows offers out of the box

### Tools
Contains the same tools as the rescue image, for more details read [this](../rescue/README.md)

