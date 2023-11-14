### BUILD WITH [docker build -t custom-tomcat --build-arg root_pass=xyz .]
### RUN WITH [docker run -it --rm -p 8888:8080 -p 2222:22 --name tomcat9 custom-tomcat]

# Download base image : tomcat 9.0 with jdk 17
FROM tomcat:9.0-jdk17

# LABEL about the custom image
LABEL maintainer="michel.mbem@gmail.com"
LABEL version="0.1"
LABEL description="This is a custom Docker image for Tomcat."

# Switch to the root user account
USER root

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt update

# Install all the required packages from ubuntu repository
RUN apt install -y ssh
RUN rm -rf /var/lib/apt/lists/*
RUN apt clean

# Copy the files to the container
COPY sshd_config /etc/ssh/
COPY start.sh ./start.sh

# Define the user's password
ARG root_pass
ENV SSH_PASSWD "root:${root_pass}"
RUN echo "$SSH_PASSWD" | chpasswd

# Create the /var/run/sshd directory
RUN mkdir /var/run/sshd

# Volume configuration
VOLUME ["/usr/local/tomcat"]

# Define an initial command for the container
CMD ["./start.sh"] 

# Expose Port for the Application 
EXPOSE 8080 22