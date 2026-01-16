# Stage 1: Build/Prepare
FROM ubuntu:22.04 AS builder

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
  apt-get install -y wget ca-certificates && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /build
RUN wget "https://github.com/trexminer/T-Rex/releases/download/0.26.8/t-rex-0.26.8-linux.tar.gz"


# ---

# Stage 2: Runtime
FROM nvidia/cuda:12.4.1-runtime-ubuntu22.04

RUN apt-get update && apt-get install -y \
  libuv1 \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy everything from the builder's /build folder directly into /app
COPY --from=builder /build/t-rex-0.26.8-linux.tar.gz .
RUN tar -zxf t-rex-0.26.8-linux.tar.gz
# Variable names in snake_case as per your preference
# Note: lolMiner usually needs to be executed as ./lolMiner
# -a octopus -o stratum+tcp://cfx.kryptex.network:7027 -u cfx:aar95fjcj0txnkcg8rtf84ace800my8fpewp2fj0f0/w1
CMD ["./t-rex", \
  "-a", "octopus", \
  "-o", "stratum+tcp://cfx.kryptex.network:7027", \
  "-u", "cfx:aar95fjcj0txnkcg8rtf84ace800my8fpewp2fj0f0/w1"]
