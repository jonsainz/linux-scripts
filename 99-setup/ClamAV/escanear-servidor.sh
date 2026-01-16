#!/bin/bash

# Log de escaneo en: ~/log/clamav-scan.log
mkdir -p ~/log && sudo clamscan -r / \
    --exclude-dir="^/sys" \
    --exclude-dir="^/proc" \
    --exclude-dir="^/dev" \
    --exclude-dir="^/snap" \
    --infected \
    --log=$HOME/log/clamav-scan.log
