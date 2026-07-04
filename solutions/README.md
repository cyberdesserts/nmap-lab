# Solutions reference

This is here so you can check your reading, not skip the work. If you have not
written your own `findings.md` yet, do that first.

Comparing your assessment to this one after you have made your own attempt is where
the learning happens. Reading this instead of scanning teaches nothing.

The point of the lab is not the specific ports. It is the habit of reading what you
find and turning it into an assessment. So this reference focuses on the interpretation,
not just the raw output.

---

## leaky-web

**What a full scan reveals:** a web service on port 80, and a second web service on
port 448081 that a default scan (top 1000 ports) misses entirely, so only a full-range
scan (`nmap -p-`) reveals it. Fetching each with `curl -i` shows the service on 448081
presenting as an internal staging dashboard, and both responses carrying a custom
header that leaks an internal build string.

**The reading:** this host exposes more than its front door. The service on 48081 is the
kind of forgotten or misplaced surface that should not be reachable, and the build-string
header is information disclosure. Neither is dramatic on its own. Together they say this
host has not been reviewed for what it exposes.

**Defender action:** confirm whether 48081 should be reachable at all, and if not, remove
or firewall it. Strip the internal build header. Both are cheap fixes that reduce what an
attacker learns for free.

**The lesson:** scan the full range, and read what services return rather than stopping
at port state. An open port is a question, not an answer.

---

## legacy-api

**What a version scan reveals:** a web server on 8080 whose version detection reports a
release clearly behind current. An unauthenticated `/status` endpoint returns service
metadata to anyone who asks.

**The reading, done correctly:** the host reports an outdated server version. That is the
honest finding. It is not "vulnerable to CVE-X" unless you have verified that the reported
version is genuinely affected, against a source like Snyk, OSV, the GitHub Advisory
Database, or NVD, and that a back-ported patch has not already addressed it. The
unauthenticated status endpoint is a separate finding worth noting in its own right: an API
that returns metadata without authentication is a small information leak.

**Defender action:** plan an update to a supported version, and verify current exposure
against a vulnerability database before assigning severity. Require authentication on the
status endpoint, or remove it if it serves no purpose.

**The lesson:** version detection tells you what is running, not whether it is exploitable.
Document what you observe, verify before you claim, and never assert a CVE from memory. This
is the single most important habit in the whole lab.

---

## login-portal

**What a scan and fetch reveal:** a web service on 8000. `curl -i` shows a response header
advertising the application by name, and the page content is a sign-in page. The two signals
agree.

**The reading:** this is not merely "a web server on 8000." It is the login portal for a
named application, and you can say so because two independent signals (the header and the
page content) point the same way. A login page is an authentication surface, which is where
a disproportionate share of real risk sits.

**Defender action:** confirm the portal is meant to be exposed where it is, check for default
or weak credentials on the named application, and make sure it is patched and monitored as the
authentication surface it is.

**The lesson:** identification is more than a port and a banner. Read what the service returns,
and corroborate one signal with another. A single header is a hypothesis. Two agreeing signals
is an identification.

---

## multi-service

**What a full version scan reveals:** a web service plus two further services on ports
suggesting a key-value store (6379) and a database (3306). Version detection grabs banners for
the latter two that announce specific software and versions.

**The reading:** taken as a whole, this host runs a web front end alongside data-layer services,
and at least one of them responds without requiring authentication. That combination is the
finding. A box exposing both an application and its data services, some speaking freely, is
doing more than it should expose and warrants a closer look. Note that the database and
key-value banners are claims the service is making about itself. In a real assessment you would
verify them rather than take them at face value, exactly as you would a version string.

**Defender action:** establish whether the data-layer services should be reachable from wherever
this scan originated, lock down any that respond without authentication, and verify what the
banners claim before acting on it.

**The lesson:** assess the host, do not list the ports. The deliverable is "here is what this host
is, here is what concerns me, here is what I would check next," not a table of open ports. Turning
raw output into a judgement is the whole job.

---

## The overall call

If you treated these four as one small estate, the first thing to fix is the unauthenticated
data-layer exposure on multi-service, because unauthenticated access to data services is the
highest-impact issue in the set. The outdated version on legacy-api comes next, once verified.
The exposed staging service and information disclosure on leaky-web are real but lower-impact
housekeeping.

Being able to make that prioritisation call, and justify the order, is the skill this lab is
really teaching. The scanning is just how you gather the evidence for it.
