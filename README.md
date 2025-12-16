# UniFi Controller Docker Setup with Ubuntu Base Image

This Dockerfile creates a complete UniFi Controller setup using Ubuntu as the base image, with MongoDB installed and configured locally.

## What's Included

- Ubuntu 22.04 base image
- MongoDB 7.0 installed and configured
- OpenJDK 11 (required for UniFi Controller)
- UniFi Network Controller installed and configured to use the local MongoDB instance
- All necessary ports exposed

## Building the Docker Image

To build the Docker image, run the following command:

```bash
docker build -t unifi-controller .
```

## Running the Container

Once the image is built, you can run the container with:

```bash
docker run -d --name unifi-controller \
  -p 8443:8443 \
  -p 3478:3478/udp \
  -p 10001:10001/udp \
  -p 8080:8080 \
  -p 8880:8880 \
  -p 8843:8843 \
  unifi-controller
```

## Accessing the UniFi Controller

After starting the container, you can access the UniFi Controller web interface at:

```
https://localhost:8443
```

Note: You'll see a security warning because of the self-signed SSL certificate. It's safe to proceed.

## Initial Setup

1. Open your browser and navigate to `https://localhost:8443`
2. Follow the setup wizard to configure your UniFi Controller
3. Set up your administrator account and network settings

## Ports Used

- 8443: UniFi Controller web interface (HTTPS)
- 3478: STUN protocol (UDP)
- 10001: Device discovery (UDP)
- 8080: HTTP redirect
- 8880: HTTP
- 8843: HTTPS alternative

## Data Persistence

To persist UniFi Controller data, you can add a volume mount:

```bash
docker run -d --name unifi-controller \
  -p 8443:8443 \
  -p 3478:3478/udp \
  -p 10001:10001/udp \
  -p 8080:8080 \
  -p 8880:8880 \
  -p 8843:8843 \
  -v /path/to/unifi/data:/usr/lib/unifi/data \
  -v /path/to/mongo/data:/data/db \
  unifi-controller
```

## MongoDB Configuration

The Dockerfile automatically configures MongoDB with:
- Database name: `unifi`
- Username: `unifi`
- Password: `unifi_password`

## Troubleshooting

If the UniFi Controller doesn't start properly:

1. Check the container logs: `docker logs unifi-controller`
2. Ensure MongoDB has enough time to start before UniFi tries to connect
3. Verify all required ports are available

## Security Notes

- This setup is intended for home use or testing
- For production environments, consider using the official UniFi Cloud Key or UniFi Dream Machine
- Change the default MongoDB password in a production environment

## Dockerfile Overview

The Dockerfile performs these steps:
1. Sets up Ubuntu 22.04 as the base image
2. Installs required dependencies (Java, wget, curl, etc.)
3. Adds and installs MongoDB 7.0
4. Creates a MongoDB user for UniFi
5. Adds the UniFi repository and installs the UniFi Controller
6. Configures UniFi to use the local MongoDB instance
7. Sets up a startup script that initializes MongoDB and starts UniFi
8. Exposes all necessary ports