FROM debian:bullseye

# Set non-interactive frontend to avoid prompts during installation
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update

# Install required packages
RUN apt-get install -y wget sudo \
    libcec6 libcec-dev libexpat1 libusb-1.0-0 libglib2.0-0 \
    alsa-utils alsa-oss

# Download and install Hyperion
RUN wget "https://github.com/hyperion-project/hyperion.ng/releases/download/2.0.16/Hyperion-2.0.16-Linux-arm64.deb" && \
    dpkg -i Hyperion-2.0.16-Linux-arm64.deb

# Create a symbolic link for libcec.so.4 pointing to libcec.so.6
RUN ln -s /usr/lib/aarch64-linux-gnu/libcec.so.6 /usr/lib/aarch64-linux-gnu/libcec.so.4

# Clean up unnecessary packages
RUN apt-get clean

# Set default values for UID and GID
ENV UID=1000
ENV GID=1000

# Create the group and user with the specified UID and GID
RUN groupadd -g ${GID} hyperion && \
    useradd -r -u ${UID} -s /bin/bash -g hyperion hyperion

# Add user to the 'video' and 'audio' groups for necessary permissions
RUN usermod -aG video hyperion && \
    usermod -aG audio hyperion

# Expose relevant ports for Hyperion
EXPOSE 19400 19444 19445 19333 2100 8090 8092

# Create the start.sh script to configure permissions and start Hyperion
RUN echo "#!/bin/bash" > /start.sh && \
    echo "chown -R hyperion:hyperion /config" >> /start.sh && \
    echo "exec /usr/bin/hyperiond -v --service -u /config" >> /start.sh

# Make sure the script is executable
RUN chmod +x /start.sh

# Set volume for config persistence
VOLUME /config

# Run Hyperion with the specified user
CMD [ "bash", "/start.sh" ]
