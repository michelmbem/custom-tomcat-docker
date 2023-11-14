# Custom Docker image for Apache Tomcat with SSH support

### Docker commands

For building:
```
docker build -t custom-tomcat --build-arg root_pass=xyz .
```

For running:
```
docker run -it --rm -p 8888:8080 -p 2222:22 --name tomcat9 custom-tomcat
```

### Interface

The image exposes two TCP ports:

* **8080** for Apache Tomcat
* **22** for OpenSSH Server

The `/usr/local/tomcat` directory is persisted as a volume

An argument is required for building the image : **root_pass**.
It is used as default password for the container's _root_ user.

### Startup

Upon startup the container launches the OpenSSH server daemon
and then starts Apache Tomcat. That's achieved by invoking the _start.sh_ script.

### Interaction with the SSH server

From any client machine the user should generate a SSH key and share it with the running container. This can be achieved by invoking the following commands:

```sh
# Generate a key pair (accept the defaults for any prompt: no passphrase in particular)
ssh-keygen

# Share the public key with the running container (assuming its 22 port is bound to the host's 2222 port)
ssh-copy-id -p 2222 root@localhost

# Test the connection
ssh -p 2222 root@localhost

# Also test SCP which might be more usefull for CI/CD tools
scp -P 2222 path/to/local/file root@localhost:/path/to/remote/file
```

**N.B.:** In the above commands replace `localhost` with `host.internal.docker` if the client machine is a container sunning on the same docker instance.