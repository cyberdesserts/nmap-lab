# Walkthrough: profiling a server with nmap

This is the hands-on part. You have four hosts to scan, each one built to teach a
different piece of what it means to look at a server you have never seen and work
out what it is, what it exposes, and what someone responsible for defending it
should care about.

Work through them in order. Each target builds on the reading habit the last one
taught. By the end you will have written a findings report that is yours, in your
words, about hosts you assessed yourself.

If you have not read the README yet, read the short safety note in it first. The
one-line version: these targets live inside your own sealed Codespace and exist
to be scanned. The same is not true of anything else, and the habits here are for
your own lab, your own kit, or systems you are authorised to test.

---

## Why this matters

Discovery is the least glamorous part of security work and one of the most
important. Before anyone hardens a server, hunts a threat on it, or responds to an
incident involving it, someone has to answer a plain question: what is this host
running, and what can be reached?

Get that wrong and everything downstream is built on a bad map. The forgotten
service on a high port, the admin panel nobody remembered was public, the API that
answers without asking who you are: these are not exotic findings. They are the
ordinary stuff of real estates, and they are found by looking properly rather than
assuming the obvious ports tell the whole story.

nmap is the tool most people reach for first, and reaching for it is easy. Reading
what it gives back with judgement is the skill. That is what this lab is for.

---

## What you will need

Everything is already in your Codespace. nmap and curl are installed, and the four
targets are running alongside your workspace. You reach each target by name:
`leaky-web`, `legacy-api`, `login-portal`, and `multi-service`.

You do not need root, and that is deliberate. Read the next section before your
first scan so the behaviour makes sense.

Time: about 60 to 90 minutes for all four, including writing your findings. Stop
after any target and come back if you need to.

---

## One thing to understand before you scan: privileges

Your workspace runs as a normal user, not root. This is the realistic default on
most systems you will ever touch, and it changes how nmap behaves.

nmap's default and fastest scan is a SYN scan (`-sS`), and it needs root because it
crafts raw packets. As a normal user, nmap quietly falls back to a TCP connect scan
(`-sT`), which completes the full connection instead. You will see a note about
this the first time you run a scan without specifying a type.

For this lab the connect scan is fine and you should use it. It is worth knowing the
difference exists, because in real work the scan type you can use is often decided
for you by the access you have. If you want to read more on scan types and when each
matters, the nmap scanning guide covers it:
https://blog.cyberdesserts.com/nmap-network-scanning-guide/

Do not reach for `sudo` to force a SYN scan here. Learning to read what an
unprivileged scan gives you is the more useful habit, because it is the situation
you will most often be in.

---

## Target 1: leaky-web

**The goal:** find everything this web host exposes, not just the obvious. Then read
what its responses give away.

### Scan it

Start with a straightforward scan of the default port range:

```
nmap leaky-web
```

You will see port 80 open, a web server. That is the front door and it is expected.
Nothing alarming yet.

Now widen the net. The default scan checks the most common 1000 ports. Real hosts do
not confine themselves to common ports, and neither should your scan when you want a
complete picture:

```
nmap -p- leaky-web
```

`-p-` scans all 65535 ports. This time a second service appears, on port 48081.

### What you are seeing

The host is running a second web service on a non-standard high port. A scan limited
to the usual suspects would have missed it entirely, and you would have walked away
with a false sense of what this host exposes.

Fetch what each service returns. nmap told you *that* a web service is there; curl
tells you *what* it is:

```
curl -i http://leaky-web/
curl -i http://leaky-web:48081/
```

The `-i` flag includes the response headers. Read them, because two things are worth
your attention.

The service on 48081 describes itself as an internal staging dashboard, the kind of
thing that is never meant to be reachable. Both responses also carry a custom header
that leaks an internal build string. That header is information disclosure: the server
is volunteering detail about its own internals to anyone who asks.

### The common mistake

The mistake here is stopping at the default scan. A quick `nmap leaky-web`, port 80
open, web server, move on.

The second service on 48081 is exactly the kind of thing that gets found by attackers
doing a full scan and missed by defenders doing a quick one. If your map only shows
the front door, you are not defending the building.

The second mistake is treating an open port as an answer. Port 48081 being open tells
you almost nothing on its own.

Fetching it and reading that it is an exposed staging dashboard tells you why it
matters. Port state is a question, not an answer.

### What this looks like in practice

Finding services on unexpected ports is a large part of external attack surface work.
The reason companies pay for attack surface management is that estates grow forgotten
corners: a staging box someone stood up and never took down, a service moved to a
non-standard port and lost track of. The skill of scanning the full range and reading
what you find is the manual version of what those tools automate.

Information disclosure in headers is the sort of finding that fills real assessment
reports. It is rarely a critical on its own, but it is the kind of detail that helps
an attacker and that a defender can remove cheaply. Noticing it, and being able to
explain why it is worth removing, is the job.

---

## Target 2: legacy-api

**The goal:** identify the service and its version, and document an outdated component
the right way, which means honestly.

### Scan it

Find the service and ask nmap to identify its version:

```
nmap -sV -p 8080 legacy-api
```

`-sV` turns on version detection. nmap probes the service and reports back not just
that something is listening on 8080, but what it believes the software and version to
be. You will see a web server reported at a version that is visibly behind current.

### What you are seeing

nmap is telling you the host runs an older release of a common web server. That is a
useful, real observation, and it is also where discipline starts to matter.

Fetch the service to confirm what it is and see what it offers:

```
curl -i http://legacy-api:8080/
curl http://legacy-api:8080/status
```

The `/status` endpoint answers, and it answers without asking who you are. An
unauthenticated endpoint that returns service metadata is itself worth noting. An API
that talks freely to anyone is a finding independent of any version number.

### The common mistake

Here is the mistake this target exists to train you out of. You see an old version,
you remember there was a nasty CVE for that software around that era, and you write
"vulnerable to CVE-whatever" in your notes.

Do not do that. Version detection tells you what is running, not whether it is
exploitable.

The reported version can be wrong, back-ported patches can fix a vulnerability while
leaving the version string unchanged, and your memory of which CVE affected which
version is not a source. What you actually know is this: the host reports an outdated
version. That is what you write.

If you want to go further, verify. Check the version against a vulnerability database,
Snyk, OSV, the GitHub Advisory Database, or NVD, and cite what you find.

The move is "this reports version X, which per [source] has known issues Y," never
"this is vulnerable" from memory. That discipline is the difference between an
assessment someone can act on and a guess that wastes their time.

### What this looks like in practice

Every vulnerability assessment and pen test involves exactly this judgement, dozens of
times. Version detection produces a long list of "this looks old." The value is not in
generating that list, a scanner does that. The value is in knowing which findings are
real, verifying them against a source, and not crying wolf on the ones that are not.

An analyst who reports ten unverified "vulnerabilities" that turn out to be
back-ported and safe loses the room. The one who reports three verified issues and
says so gets listened to. Honest documentation is a skill, and it is rarer than it
should be.

---

## Target 3: login-portal

**The goal:** work out what an application *is*, not just that it is there.

### Scan it

```
nmap -sV -p 8000 login-portal
```

A web service on 8000. Version detection gives you the server software, but that only
tells you what is serving the page, not what the application behind it does.

### What you are seeing

Fetch the page and read it:

```
curl -i http://login-portal:8000/
```

Two signals. The response carries a header advertising the application by name, and
the page content itself is a sign-in page. Put together, you can now say something
specific: this is not just "a web server on 8000," it is a login portal for a named
application.

That shift, from "a port is open" to "this is a specific application's login page," is
the whole point of this target. A port number and a server banner are the start of
identification. Reading what the service returns is what completes it.

### The common mistake

The mistake is letting nmap's output be the end of the investigation. nmap is superb at
telling you a service exists and hazarding what it is.

It does not tell you that the thing on 8000 is a login page for a particular product
with its own known default credentials, configuration quirks, and attack surface. Only
looking does that.

The related mistake is trusting a single signal. A header claiming the application name
is a claim, not proof, since headers can be changed or spoofed.

You corroborate it with the page content. One signal is a hypothesis, and two agreeing
signals is an identification.

### What this looks like in practice

Application identification is foundational to almost everything that comes after it. A
threat hunter triaging exposed services, a SOC analyst assessing what an alert is really
about, a pen tester deciding where to spend time: all of them need to know not just that
a service exists but what it is, because the *what* determines the risk and the response.

Login pages specifically are worth recognising quickly, because a login page is an
authentication surface, and authentication surfaces are where a lot of real risk
concentrates. Being able to spot one, name the application, and know where to look next
is a small skill that comes up constantly.

---

## Target 4: multi-service

**The goal:** pull several services together into one coherent assessment of a host. This
is the target your findings report is really about.

### Scan it

Scan the full range and identify versions in one go:

```
nmap -sV -p- multi-service
```

This host is busier. You will find a web service and two more services on ports that
suggest a database and a cache or key-value store.

### What you are seeing

Look at what nmap reports for each port, then think about what the *combination* means
rather than each port alone.

Fetch the web service:

```
curl -i http://multi-service/
```

For the other two, nmap does not give you a clean version line. It reports them as
`mysql?` and `redis?`: it recognises the ports as a database and a key-value store but
cannot confirm an exact version, so instead of a tidy VERSION column it prints the raw
service banners in an "unrecognized fingerprint" block below the port table. That block
is where the banner text actually lives. Read it, and read it sceptically.

A banner announcing a particular database and version is the service telling you what it
is. Services can be configured to announce anything, so a banner is a claim you would
verify before relying on it, exactly as you would a version string. In a real assessment
you would confirm; here, note what is claimed and flag that it is a claim.

Now do the synthesis. You have a host running a web front end plus what present as a
database and a key-value store, some of them speaking freely without authentication. The
question is not "what is on port 6379." The question is "what is this host, taken as a
whole, and what would concern a defender about it?"

### The common mistake

The mistake is reporting ports instead of assessing a host. A findings list that reads
"80 open, 6379 open, 3306 open" is data, not an assessment. It leaves the reader to do
the thinking you were supposed to do.

The assessment is the synthesis: this host exposes a web application alongside data-layer
services, at least one of which responds without authentication, which together suggest a
box that is doing more than it should expose and is worth a closer look. That sentence is
worth more than the raw port list, because it tells someone what to *do*.

### What this looks like in practice

This is what separates someone who can run a scanner from someone who can assess a system.
Tools produce port lists all day. Turning a port list into "here is what this host is, here
is what concerns me, here is what I would check next" is the actual deliverable, whether you
are writing a pen test report, triaging in a SOC, or scoping an incident.

The habit to build: always close the loop from raw output to a human-readable judgement.
The scan is the evidence. The assessment is the point.

---

## Now write your findings

You have scanned four hosts. The final task is the one that matters most in real work:
write it up.

Open `findings.md` in this repo and fill it in for each host. For every target, capture:

- What you scanned and how (the commands you ran)
- What you found (services, ports, versions, what each service returned)
- Your interpretation (what it means, not just what it is)
- What a defender should do about it

Write it in your own words. The point is not to reproduce the reference, it is to practise
turning what you found into an assessment someone could act on. When you are done, compare
against `solutions/` to check your reading, not to copy it.

That findings document is what you take away from this lab. It is portable proof that you can
look at a set of hosts you have never seen, work out what they are, and communicate it the way
the work actually requires.

---

## Where to take this next

- The nmap scanning guide for deeper scan-type and timing control:
  https://blog.cyberdesserts.com/nmap-network-scanning-guide/
- The nmap NSE scripting engine, for automating the kind of service investigation you did
  here by hand: https://blog.cyberdesserts.com/nmap-nse-scripting-engine/
- Setting up a fuller practice lab:
  https://blog.cyberdesserts.com/cybersecurity-practice-lab-setup/

When you are finished, stop your Codespace, and delete it if you are done, to stay within the
free tier. The README explains why both steps matter.
