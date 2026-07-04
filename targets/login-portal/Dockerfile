# Scenario 3 : login-portal
#
# A host serving a recognisable login page. The lesson is IDENTIFYING WHAT AN
# APPLICATION IS, not just noting that a port is open. nmap tells you a web
# service is listening. curl fetching the page tells you it is a login portal
# for a specific kind of application. That distinction is the whole point:
# port state is not identification.

FROM nginx:1.27-alpine

COPY default.conf /etc/nginx/conf.d/default.conf
COPY site/ /usr/share/nginx/html/

EXPOSE 8000
