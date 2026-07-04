#!/bin/bash
# Runs once in your first terminal when the Codespace opens (wired via ~/.bashrc).
# Confirms the toolkit is present, points the reader at their first step, and opens
# the walkthrough. Kept deliberately simple: a friendly "you're ready".

echo ""
echo "=================================================="
echo "  nmap-lab is ready."
echo "=================================================="
echo ""

# Confirm the tools are installed.
if command -v nmap >/dev/null 2>&1; then
    echo "  [ok] nmap installed:  $(nmap --version | head -n 1)"
else
    echo "  [!!] nmap not found. Try rebuilding the Codespace."
fi

if command -v curl >/dev/null 2>&1; then
    echo "  [ok] curl installed:  $(curl --version | head -n 1 | cut -d' ' -f1-2)"
else
    echo "  [!!] curl not found. Try rebuilding the Codespace."
fi

echo ""
echo "  The four target hosts are running alongside this workspace."
echo "  You reach them by name: leaky-web, legacy-api, login-portal, multi-service"
echo ""
echo "  Your first step:"
echo "     1. Read the walkthrough (it is opening for you now)"
echo "     2. Start with Target 1 (leaky-web)"
echo "     3. Try your first scan:   nmap leaky-web"
echo ""
echo "  When you finish, stop this Codespace to save your free compute hours,"
echo "  and delete it when you are done. The README explains why both matter."
echo ""
echo "=================================================="
echo ""

# Open the walkthrough for the reader. This runs inside the VS Code terminal
# session, so the `code` CLI can reach the editor (postAttachCommand cannot do
# this reliably). Best-effort and guarded, so running welcome.sh elsewhere is
# harmless.
if command -v code >/dev/null 2>&1; then
    code /workspaces/nmap-lab/walkthrough/README.md >/dev/null 2>&1 || true
fi
