#!/bin/sh
# contains globals that are common between the ISOs

export RELEASE=bookworm
export RELEASE_VERSION='12'
export GALENA_VERSION='0.1'
export VERSION="${RELEASE_VERSION}g$GALENA_VERSION"

export ISO_PUBLISHER='galena-linux'
export ISO_VOLUME="Galena Linux"

TIMESTAMP="$(date +'%y%m%dT%H%M')"
export TIMESTAMP

# for some reason hostname is not set in the live image
export LIVE_APPEND_BOOT="boot=live hostname=debian components config"

