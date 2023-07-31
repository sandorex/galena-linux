FROM debian:bookworm

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends live-build \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# debian CMD defaults to bash
