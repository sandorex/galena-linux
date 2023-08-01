#!/bin/sh
# common configuration for the live-build scripts

RELEASE=bookworm
RELEASE_VERSION='12'
GALENA_VERSION='0.1'
VERSION="${RELEASE_VERSION}g$GALENA_VERSION"

ISO_PUBLISHER='galena-linux'

TIMESTAMP="$(date +'%y%m%dTH%M%S')"
IMAGE_NAME_PREFIX="galena"
IMAGE_NAME_SUFFIX="$VERSION"

