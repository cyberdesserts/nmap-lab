#!/bin/sh
# Start the web server and two canned banner services.
# The banner services just emit a recognisable service string on connect,
# so nmap -sV has something to fingerprint. They are not real databases.

# Redis-like service on 6379, deliberately UNAUTHENTICATED. It answers with
# server internals (version, keyspace) the moment you connect, without asking
# who you are. An open Redis with no password is one of the most common
# real-world data-layer findings, so this is the exposure the multi-service
# assessment is built around.
#
# The banner is written to a file first, then served with `cat`, because socat
# parses commas in a SYSTEM: command as address options and the INFO keyspace
# line contains commas.
printf '# Server\r\nredis_version:7.0.11\r\nredis_mode:standalone\r\nos:Linux 6.1\r\narch_bits:64\r\n# Clients\r\nconnected_clients:1\r\n# Keyspace\r\ndb0:keys=128,expires=0,avg_ttl=0\r\n' > /tmp/redis-info
socat TCP-LISTEN:6379,reuseaddr,fork SYSTEM:'cat /tmp/redis-info' &

# MySQL-like banner on 3306
socat TCP-LISTEN:3306,reuseaddr,fork SYSTEM:'printf "\x4a\x00\x00\x00\x0a5.7.42-lab\x00"' &

# Web server in the foreground
nginx -g 'daemon off;'
