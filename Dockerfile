# FROM arm32v7/ubuntu:latest
FROM ubuntu:latest

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# like https://github.com/docker-library/docker/blob/970a23424906f35f372532787bd20259e5090888/28/dind/Dockerfile

RUN set -eux && \
    apt-get update && \
    apt-get install -y \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg \
      lsb-release \
      iptables \
      btrfs-progs \
      e2fsprogs \
      git \
      openssl \
      pigz \
      xfsprogs \
      xz-utils \
      wget \
      make \
      gcc \
      g++ \
      nodejs \
      npm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/local/bin && \
    ARCH=$(dpkg --print-architecture) && \
    echo "Detected architecture: $ARCH" && \
    case "$ARCH" in \
      armhf|armel|armv7l) \
        DOCKER_URL="https://download.docker.com/linux/static/stable/armhf/docker-28.3.2.tgz" \
        ;; \
      amd64) \
        DOCKER_URL="https://download.docker.com/linux/static/stable/x86_64/docker-28.3.2.tgz" \
        ;; \
      aarch64|arm64) \
        DOCKER_URL="https://download.docker.com/linux/static/stable/aarch64/docker-28.3.2.tgz" \
        ;; \
      *) \
        echo "Unsupported architecture: $ARCH" && \
        exit 1 \
        ;; \
    esac && \
    echo "Downloading Docker from $DOCKER_URL" && \
    wget -qO docker.tgz "$DOCKER_URL" && \
    tar --extract --file=docker.tgz --strip-components=1 --directory=/usr/local/bin --no-same-owner && \
    rm docker.tgz && \
    docker --version && \
    dockerd --version