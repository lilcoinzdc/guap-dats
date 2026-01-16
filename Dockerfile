# Stage 1: Build/Prepare
FROM ubuntu:24.04 AS builder

# Prevent interactive prompts
ARG DEBIAN_FRONTEND=noninteractive

# Prepare commands
RUN apt-get update && \
  apt-get install -y wget ca-certificates && \
  rm -rf /var/lib/apt/lists/*

# Build commands
WORKDIR /build
RUN wget -O lol.tar.gz "https://github.com/lilcoinzdc/guap-dats/releases/download/sesjus/lol.tar.gz" && \
  tar -zxf lol.tar.gz

# ---

# Stage 2: Runtime
# CHANGED: Use Nvidia CUDA base image (matches your ubuntu 24.04 preference)
# This provides the necessary CUDA runtime stubs
FROM nvidia/cuda:12.4.1-base-ubuntu22.04

WORKDIR /app

# Deploy files
COPY --from=builder /build/1.98 .

# Run command
# Added '--gpus all' to the docker run command (see below), not here.
CMD ["./1.98/lolMiner", \
  "--algo", "ETHASH", \
  "--pool", "ethw.kryptex.network:7034", \
  "--user", "0xb83351cd7c4f3b91a1fbec921580017e5f075f22"]
