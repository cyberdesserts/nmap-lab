# nmap-lab

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/cyberdesserts/nmap-lab)

Click the badge above to launch the lab in your browser. You need a free GitHub
account and one click, with nothing to install or configure.

If you have not used Codespaces before, the Quick Start below walks through it.

A hands-on lab for learning to profile a server with nmap, the way it actually
gets done: discover what is listening, work out what each service is, spot what
a defender should be worried about, and write it up. You scan a small set of
sandboxed target hosts that run entirely inside your own cloud dev environment.
No local setup, no hardware, and nothing exposed to the internet.

Everything here runs in GitHub Codespaces. You own the environment, you own your
work, and you tear it down when you are done.

---

## Quick start (one click)

New to GitHub? That is fine. You do not need to install anything, and you do not
need to know how git works.

You need a free GitHub account and one click.

**The fastest way:** click the **Open in GitHub Codespaces** badge at the top of
this page. If you are signed in to GitHub, it takes you straight to the launch
screen. Press the green **Create codespace** button there and you are done.

**If you would rather do it by hand:**

1. Sign in to GitHub, or create a free account at https://github.com/signup
2. On this repository page, click the green **Code** button
3. Choose the **Codespaces** tab, then **Create codespace on main**

**What happens next, either way:** GitHub builds your own private copy of the lab
in the browser, which takes a couple of minutes the first time.

When it is ready, a full code editor opens in your browser. A welcome message
appears in the terminal at the bottom, telling you exactly what to do first.

You never touch git, and you never install anything. The environment runs on
GitHub's computers, not yours. When you are finished you stop it, and delete it
when you are done, which the free-tier section below explains.

---

## What you will learn

By the end you will be able to:

- Discover what services a host is running, including services hiding on
  non-standard ports
- Detect service versions and document an outdated component honestly, without
  asserting a vulnerability you have not verified
- Identify what an application *is* by reading what it returns, not just noting
  that a port is open
- Synthesise several open ports into one coherent assessment of a host
- See your own scan from the target's side, and understand why scan noise matters

This is discovery and assessment, the defensive reading of a host. It is not an
exploitation lab and it does not teach attacks.

---

## Before you start: this is a lab, and only a lab

The targets in this repo exist to be scanned. They live only inside your own
Codespace, on a sealed internal network with no route to or from the internet.
You are scanning your own throwaway environment.

Scanning hosts or networks you do not own and are not explicitly authorised to
test is a different thing entirely, and in most places it is illegal. The skills
here are for your own lab, your own kit, or systems you have written permission
to assess.

Nothing in this repo should be pointed at anything else. That line is the whole
reason the lab is built the way it is.

---

## What you will need

- A GitHub account (the free tier is enough, see the note on staying within it
  below)
- Basic comfort with a terminal: you can open one, type a command, and read the
  output
- No prior nmap experience required. No local installs. nmap and curl are
  already in the environment.

Realistic time: **60 to 90 minutes** to work through all four targets properly,
including reading and documenting your findings. You can stop after any target
and come back.

If you want the conceptual grounding first, these companion articles pair with
the lab:

- Nmap network scanning guide: https://blog.cyberdesserts.com/nmap-network-scanning-guide/
- Getting started with Docker: https://blog.cyberdesserts.com/getting-started-with-docker/
- Setting up a cybersecurity practice lab: https://blog.cyberdesserts.com/cybersecurity-practice-lab-setup/

---

## Getting started

Launching is covered in the Quick Start above. Once your Codespace opens, the
four target hosts are already running alongside your workspace, reachable by
name: `leaky-web`, `legacy-api`, `login-portal`, and `multi-service`.

Open `walkthrough/README.md` and start with the first target.

You do not need root. The workspace runs as a normal user, which is the
realistic default and shapes how some scans behave. The walkthrough explains
this where it matters.

---

## Staying within the free tier

GitHub gives personal accounts 120 Codespaces core-hours a month, free. Compute
is billed in *core-hours*, which is machine cores multiplied by runtime, so the
machine size and the time it stays running both matter.

Three things keep you comfortably inside the free allowance:

**The machine is already set to the smallest option (2-core).** This repo
requests it for you. A 2-core machine spends your 120 core-hours over 60 real
hours; a 4-core machine would burn through them in 30. You do not need more than
2 cores for this lab.

**Lower your idle timeout.** By default a Codespace keeps running for 30 minutes
after you stop interacting with it, and it spends compute the whole time. In
your GitHub Codespaces settings you can drop the default idle timeout to as low
as 5 minutes. 10 to 15 minutes is a sensible setting for lab work.

**Stop, then delete, when you are done.** Stopping a Codespace ends compute
usage, but a *stopped* Codespace still consumes your storage allowance until you
delete it.

When you have finished the lab and saved your `findings.md` (see **What you walk
away with** below), delete the Codespace at https://github.com/codespaces. Stop
and delete are two separate actions, and you want both.

None of this is required to complete the lab. It is here because managing cloud
compute cost is itself a real skill, and because nobody enjoys an unexpected
"you have reached your limit" message.

---

## Difficulty: make it harder or easier

The walkthrough runs one clean path that assumes basic knowledge. If you want to
adjust the challenge, the walkthrough marks where you can:

### Easier
- Follow the walkthrough commands as written and focus on reading the output
- Use the `solutions/` reference to check your interpretation as you go

### Standard (default)
- Work through each target using the walkthrough as a guide, but try each scan
  before reading the explanation
- Write your own findings before comparing to the reference

### Harder
- Read only the goal for each target, then work out the scans yourself
- Do not open `solutions/` until you have written your full findings report
- Time-box each target and treat it like a real assessment

---

## What you walk away with

A completed `findings.md`: your own written assessment of the four hosts, in your
words. That document is the point. It is portable proof that you can scan a set
of hosts, read what you find, and communicate it the way the work actually
requires.

**Save it before you delete.** Your Codespace is disposable, and deleting it
deletes `findings.md` along with it. Before you tear it down, keep your work: in
the file explorer, right-click `findings.md` and choose **Download** (the simplest
option), or copy its contents somewhere safe. If you are comfortable with git, you
can instead fork this repo and push your findings to your own copy.

---

## Where this fits

This is one lab in a growing set. It teaches discovery, the widest and most
common starting skill. Later labs go deeper into service enumeration, the
defensive side (collecting and reading logs at scale), and internal-network
scenarios.

Built by CyberDesserts. More at https://blog.cyberdesserts.com/
