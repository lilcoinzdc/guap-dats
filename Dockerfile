# Stage 1: Build/Prepare
FROM ubuntu:22.04 AS builder

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
  apt-get install -y wget ca-certificates && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /build
RUN wget -O lol.tar.gz "https://github.com/Lolliedieb/lolMiner-releases/releases/download/1.98/lolMiner_v1.98_Lin64.tar.gz" && \
  tar -zxf lol.tar.gz --strip-components=1

# ---

# Stage 2: Runtime
FROM nvidia/cuda:12.4.1-runtime-ubuntu22.04

RUN apt-get update && apt-get install -y \
  libuv1 \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy everything from the builder's /build folder directly into /app
COPY --from=builder /build .

# Variable names in snake_case as per your preference
# Note: lolMiner usually needs to be executed as ./lolMiner
CMD ["./lolMiner", \
  "--algo", "OCTOPUS", \
  "--pool", "cfx-eu.kryptex.network:7027", \
  "--user", "cfx:aar95fjcj0txnkcg8rtf84ace800my8fpewp2fj0f0/r0"]
