# Use Ubuntu as the base image
FROM ubuntu:22.04

# Set environment variables to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Set working directory
WORKDIR /root

# Update system and install basic utilities
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    wget \
    curl \
    gnupg \
    lsb-release \
    ca-certificates \
    apt-transport-https \
    systemd \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Install OpenJDK 11 (required for UniFi Controller)
RUN apt-get update && \
    apt-get install -y openjdk-11-jre-headless && \
    rm -rf /var/lib/apt/lists/*

# Install MongoDB
# Import MongoDB public key
RUN wget -qO - https://www.mongodb.org/static/pgp/server-7.0.asc | apt-key add -

# Add MongoDB repository
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list

# Install MongoDB
RUN apt-get update && \
    apt-get install -y mongodb-org && \
    rm -rf /var/lib/apt/lists/*

# Create MongoDB data directory
RUN mkdir -p /data/db

# Copy MongoDB init script
COPY init-mongo.sh /tmp/init-mongo.sh
RUN chmod +x /tmp/init-mongo.sh

# Add UniFi repository
RUN echo 'deb http://www.ui.com/downloads/unifi/debian stable ubiquiti' | tee /etc/apt/sources.list.d/100-ubnt.list && \
    wget -O /etc/apt/trusted.gpg.d/ubiquiti.asc https://dl.ui.com/unifi/unifi-repo.gpg && \
    sleep 3

# Install UniFi Controller
RUN apt-get update || (echo "Update failed, retrying..." && sleep 5 && apt-get update)
RUN apt-get install -y unifi
RUN rm -rf /var/lib/apt/lists/*

# Configure UniFi to use local MongoDB
RUN sed -i 's|db.mongo.local=false|db.mongo.local=true|g' /etc/unifi/system.properties && \
    sed -i 's|db.mongo.url=|db.mongo.url=mongodb://unifi:unifi_password@localhost:27017/unifi|g' /etc/unifi/system.properties

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose UniFi Controller ports
EXPOSE 8443 3478/udp 10001/udp 8080 8880 8843

# Start the services
CMD ["/start.sh"]