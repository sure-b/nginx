# Use the official Nginx base image
FROM nginx:latest

# Update & install sudo and other tools
RUN apt-get update && \
    apt-get install -y sudo passwd && \
    rm -rf /var/lib/apt/lists/*

# Create a new user with password and sudo privileges
RUN useradd -ms /bin/bash vivritiadmin && \
    echo "vivritiadmin:adminpass" | chpasswd && \
    usermod -aG sudo vivritiadmin && \
    echo "vivritiadmin ALL=(ALL) ALL" >> /etc/sudoers

# Disable root login:
# - Lock the root account
# - Disable root shell
RUN passwd -l root && \
    usermod -s /usr/sbin/nologin root

# Create writable temp directories
RUN mkdir -p /home/vivritiadmin/nginx_temp/{client_body,proxy,fastcgi,scgi,uwsgi} \
 && touch /home/vivritiadmin/nginx_temp/access.log /home/vivritiadmin/nginx_temp/error.log \
 && chown -R vivritiadmin:vivritiadmin /home/vivritiadmin/nginx_temp

# Copy custom nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf    

# Optional: switch to the admin user by default
# USER admin
CMD ["nginx", "-g", "daemon off;"]