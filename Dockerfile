# Use the official MongoDB image as base
FROM mongo:8.2.2-noble

# Set working directory
WORKDIR /app

# Copy the init-mongo script to the initialization directory
COPY init-mongo.sh /docker-entrypoint-initdb.d/init-mongo.sh

# Set environment variables with default values
ENV MONGO_INITDB_ROOT_USERNAME=root
ENV MONGO_INITDB_ROOT_PASSWORD=rootpassword
ENV MONGO_USER=unifi
ENV MONGO_PASS=unifipassword

# Expose MongoDB port
EXPOSE 27017

# Default command to start MongoDB with authentication
CMD ["mongod", "--auth", "--bind_ip_all"]