IMAGE := "localhost/live-build"
PODMAN_ARGS := "--rm -it --privileged -v .:/build:exec,dev,z " + env_var_or_default("LIVE_BUILD_PODMAN_ARGS", "") + " '" + IMAGE + "'"

_default:
    @just --list

# builds the minimal debian container with live-build
_container_image:
    @sudo podman image exists localhost/live-build:latest \
        || sudo podman build -f {{justfile_directory()}}/Containerfile -t "{{IMAGE}}"

# build the rescue iso
build-rescue *args: _container_image
    sudo podman run -w /build/rescue {{PODMAN_ARGS}} sh -c 'lb clean && lb config {{args}} && lb build'

# build the installer iso
build-installer *args: _container_image
    sudo podman run -w /build/installer {{PODMAN_ARGS}} sh -c 'lb clean && lb config {{args}} && lb build'

