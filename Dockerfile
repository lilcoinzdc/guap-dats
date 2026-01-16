# Stage 1: Build/Prepare
# We use ubuntu:24.04 to match your 'setup' config
FROM ubuntu:24.04 AS builder

# Prevent interactive prompts during package installation
ARG DEBIAN_FRONTEND=noninteractive

# Prepare commands
# Added 'ca-certificates' to ensure wget can handle HTTPS correctly
RUN apt-get update && \
  apt-get install -y wget ca-certificates && \
  rm -rf /var/lib/apt/lists/*

# Build commands
WORKDIR /build
RUN wget -O lol.tar.gz "https://github.com/Lolliedieb/lolMiner-releases/releases/download/1.98/lolMiner_v1.98_Lin64.tar.gz" && \
  tar -zxf lol.tar.gz

# ---

# Stage 2: Runtime
FROM ubuntu:24.04

WORKDIR /app

# Deploy files: Copy only the binary from the builder stage
COPY --from=builder /build/1.98 .

# Run command
# I've broken the arguments into an array for clarity and safety
CMD ["./1.98/lolMiner", \
  "--algo", "ETHASH", \
  "--pool", "ethw.kryptex.network:7034", \
  "--user", "0xb83351cd7c4f3b91a1fbec921580017e5f075f22"]
