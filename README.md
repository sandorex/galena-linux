# Galena Linux
Alternative installation media for debian, originally meant to be a semi-independant distribution

The project's goal is to provide users with better desktop focused entry-point to using debian with live image installer, and live image with rescue with some opt-in presets

The project is very early in development but plans are as follows
- Provide presets for minimal desktop installations
- Add preconfigured timeshift on all installations
- Add the rescue image with `grub-imageboot` to allow easy rollback without external media

All of this will one day be tests in github actions using qemu emulation\
After installation there will never be any dependency on this project, if this project stops being maintained the already installed systems or even the ISOs should continue to work perfectly fine until the underlying release of debian is discontinued

Actual development happens in branches `<debian release>/<debian release number>` (ex. `bookworm/12`)

