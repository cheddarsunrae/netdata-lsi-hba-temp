# netdata-lsi-hba-temp

Netdata external plugin for Art of Server's `lsi-hba-temp` journal/syslog output.

This package does not poll HBA hardware directly. It expects `lsi-hba-temp` to run as a root-owned systemd service and emit journal/syslog payloads like:

```text
[PAYLOAD] pci=0000:01:00.0 chip=SAS2308 gen=SAS2 temp_c=64 status=ok
```

The Netdata plugin reads those journal entries as the `netdata` user and publishes:

- `lsi_hba_temp.temperature` — HBA controller temperature in degrees Celsius.
- `lsi_hba_temp.state` — one-hot state chart with `ok`, `warning`, `critical`, and `unknown`.

## Why journal mode?

This avoids giving Netdata direct hardware access, sudo rights, or `/dev/mptctl` access.

```text
lsi-hba-temp.service, root -> reads hardware -> writes journal/syslog
Netdata plugin, netdata user -> reads journal -> charts metrics
```

## Requirements

- Netdata Agent
- `lsi-hba-temp`
- systemd/journald
- `netdata` user can read journal entries, usually by membership in `systemd-journal`

## Install manually

```bash
sudo install -m 0755 src/plugins.d/lsi_hba_temp.plugin /usr/libexec/netdata/plugins.d/lsi_hba_temp.plugin
sudo install -m 0644 src/health.d/lsi_hba_temp.conf /etc/netdata/health.d/lsi_hba_temp.conf
sudo usermod -aG systemd-journal netdata
sudo systemctl restart netdata
```

## Test

```bash
journalctl -t lsi-hba-temp -n 20 --no-pager -o cat
sudo -u netdata /usr/libexec/netdata/plugins.d/lsi_hba_temp.plugin 10
```

## Support and requests

Use this repository's GitHub Issues page for bug reports, feature requests, packaging issues, and support questions.

## License

GPL-3.0-or-later. See `LICENSE`.

## Notes

If an older local test emitted `lsi_hba_temp.status`, Netdata may retain that stale chart in its local cache. This package emits `lsi_hba_temp.state`, not `lsi_hba_temp.status`.

There is generally no clean per-chart delete. Ignore/wait for stale data to age out, or clear Netdata local metric cache if you accept losing local history.
