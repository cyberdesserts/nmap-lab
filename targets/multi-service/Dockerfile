# Scenario 4 : multi-service
#
# A host exposing several services at once. The lesson is SYNTHESIS: taking
# many open ports and building one coherent picture of what this host is and
# what a defender should think about it. This is the target the findings
# report is really written about, because a real host assessment is never
# about one port, it is about what the combination tells you.
#
# We run a few lightweight, recognisable services on one container using
# s6-style backgrounding via a small entrypoint. Everything is static or
# canned. Nothing accepts meaningful input.

FROM alpine:3.20

RUN apk add --no-cache nginx socat

# A web service (nginx) plus two canned banner services stood up with socat,
# so -sV sees a mix of recognisable service fingerprints on one host.
COPY nginx.conf /etc/nginx/nginx.conf
COPY web/ /var/www/html/
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 80: web, 6379: a Redis-like banner, 3306: a MySQL-like banner.
# The banners are canned strings, not real Redis/MySQL. The lesson is reading
# what a service ADVERTISES and forming a hypothesis, then noting that a
# banner is a claim to verify, not proof.
EXPOSE 80 6379 3306

ENTRYPOINT ["/entrypoint.sh"]
