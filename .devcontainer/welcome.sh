#!/bin/bash
# Runs once when the Codespace is created. Confirms the toolkit is present and
# points the reader at their first step. Kept deliberately simple: a friendly
# "you're ready" so someone new to all this knows nothing is broken.

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
echo "     1. Open  walkthrough/README.md"
echo "     2. Start with Target 1 (leaky-web)"
echo "     3. Try your first scan:   nmap leaky-web"
echo ""
echo "  When you finish, stop this Codespace to save your free compute hours,"
echo "  and delete it when you are done. The README explains why both matter."
echo ""
echo "=================================================="
echo ""
