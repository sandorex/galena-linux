set fallback

IMAGE := "localhost/live-build"

_default:
    @just --choose

# builds the minimal debian container with live-build
container:
    @podman image exists localhost/live-build:latest \
        || podman build {{justfile_directory()}}/.. -t "{{IMAGE}}"

# runs command in the container and then deletes the container
_run +cmd: container
    sudo podman run --rm -it --privileged -v ./live:/live:exec,dev,z -w /live "{{IMAGE}}" {{cmd}}

# configures live-build, must be ran before build
configure: (_run "lb" "config")

# builds the iso
build: (_run "lb" "build")

# cleans up live-build, leaving configuration behind
clean: (_run "lb" "clean" "--all")

