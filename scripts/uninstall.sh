#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
set -euo pipefail
for d in /usr/libexec/netdata/plugins.d /usr/lib/netdata/plugins.d /opt/netdata/usr/libexec/netdata/plugins.d; do
  rm -f "$d/lsi_hba_temp.plugin" 2>/dev/null || true
done
rm -f /etc/netdata/health.d/lsi_hba_temp.conf
systemctl restart netdata || true
echo "Removed netdata-lsi-hba-temp plugin and health config."
echo "Historical/stale charts may remain in Netdata cache until retention expires or cache is cleared."
