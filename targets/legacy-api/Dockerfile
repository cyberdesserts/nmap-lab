# Scenario 2 : legacy-api
#
# An API host running an older, pinned server version. The lesson is service
# and version detection (nmap -sV), and how to document an outdated component
# HONESTLY.
#
# The teaching point is deliberately disciplined: version detection tells you
# WHAT is running, not whether it is vulnerable. The walkthrough teaches the
# reader to record the version and then VERIFY it against a source (Snyk, OSV,
# NVD, the vendor advisory) before making any vulnerability claim. Reading a
# version number and asserting a CVE from memory is exactly the habit this lab
# trains readers OUT of.
#
# The pinned version below is old enough that -sV reports a clearly dated
# server, but it is a mundane web server serving a static JSON response. There
# is no exploit here and none is taught. The skill being built is detection
# and honest documentation, not exploitation.

# An older pinned nginx. -sV will report the version, which is visibly behind
# current. That is the observable the reader documents and then verifies.
FROM nginx:1.18-alpine

COPY default.conf /etc/nginx/conf.d/default.conf
COPY api/ /usr/share/nginx/html/

EXPOSE 8080
