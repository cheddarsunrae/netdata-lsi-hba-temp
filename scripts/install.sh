#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
set -euo pipefail
PLUGIN_SRC="${1:-src/plugins.d/lsi_hba_temp.plugin}"
HEALTH_SRC="${2:-src/health.d/lsi_hba_temp.conf}"

PLUGIN_DIR=""
for d in /usr/libexec/netdata/plugins.d /usr/lib/netdata/plugins.d /opt/netdata/usr/libexec/netdata/plugins.d; do
  if [ -d "$d" ]; then PLUGIN_DIR="$d"; break; fi
done
if [ -z "$PLUGIN_DIR" ]; then echo "Could not find Netdata plugins.d directory." >&2; exit 1; fi

install -m 0755 "$PLUGIN_SRC" "$PLUGIN_DIR/lsi_hba_temp.plugin"
mkdir -p /etc/netdata/health.d
install -m 0644 "$HEALTH_SRC" /etc/netdata/health.d/lsi_hba_temp.conf

if getent passwd netdata >/dev/null && getent group systemd-journal >/dev/null; then
  usermod -aG systemd-journal netdata
fi

systemctl restart netdata || true
echo "Installed Netdata plugin to $PLUGIN_DIR/lsi_hba_temp.plugin"
