# Workspace container: where you run nmap and curl.
#
# This is the box you drive the lab from. It has nmap and curl installed and
# sits on the same internal network as the targets, so you can reach them by
# hostname (leaky-web, legacy-api, login-portal, multi-service).

FROM debian:bookworm-slim

# nmap for scanning, curl for confirming what a service actually is,
# plus a couple of small quality-of-life tools for reading output.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        nmap \
        curl \
        ca-certificates \
        less \
        vim-tiny \
    && rm -rf /var/lib/apt/lists/*

# Non-root user for the workspace. You do not need root to run these scans
# against the lab targets, and working as a normal user is the right habit.
ARG USERNAME=analyst
RUN useradd -m -s /bin/bash ${USERNAME}
USER ${USERNAME}
WORKDIR /workspaces/nmap-lab
