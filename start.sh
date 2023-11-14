#!/bin/sh
/usr/sbin/sshd -D &
/usr/local/tomcat/bin/catalina.sh run