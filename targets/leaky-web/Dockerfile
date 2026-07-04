# Scenario 1: leaky-web
#
# A web host that gives away more than it should. Two lessons live here:
#
#   1. A second web service is bound to a NON-default high port (48081), which
#      sits OUTSIDE the 1000 ports a default nmap scan checks. A default scan
#      (nmap leaky-web) therefore misses it entirely, and only a full-range
#      scan (nmap -p- leaky-web) reveals it. This is why full-range scanning
#      matters.
#
#   2. The server returns a custom response header that discloses internal
#      build information. This teaches reading HTTP headers with curl after
#      nmap tells you a web service exists, and recognising information
#      disclosure as a finding on your own estate.
#
# Access logging is enabled so the reader can tail the log and SEE their own
# scan from the target's side. That is the light defensive lesson: your scan
# is visible from the other end.

FROM nginx:1.27-alpine

# A custom config that:
#   - listens on 80 (expected) and 48081 (the service a default scan misses)
#   - adds a header that leaks a fake internal build string (information
#     disclosure, entirely synthetic, nothing sensitive or real)
#   - keeps access logging on so scans are visible in the log
COPY default.conf /etc/nginx/conf.d/default.conf

# A minimal landing page on 80 and a different one on 48081 so curl output
# clearly distinguishes the two services.
COPY site-main/ /usr/share/nginx/html/
COPY site-admin/ /usr/share/nginx/html-admin/

EXPOSE 80 48081
