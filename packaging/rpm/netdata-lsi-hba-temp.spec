Name:           netdata-lsi-hba-temp
Version:        0.1.0
Release:        1%{?dist}
Summary:        Netdata external plugin for lsi-hba-temp journal output
License:        GPL-3.0-or-later
URL:            https://github.com/cheddarsunrae/netdata-lsi-hba-temp
Source0:        %{name}-%{version}.tar.gz
BuildArch:      noarch

Requires:       netdata
Requires:       systemd
Requires:       bash
Requires:       grep
Requires:       coreutils
Requires:       lsi-hba-temp

%description
Netdata external plugin that reads lsi-hba-temp journal/syslog payloads and
publishes LSI/Broadcom HBA temperature and state charts.

%prep
%autosetup

%install
mkdir -p %{buildroot}%{_libexecdir}/netdata/plugins.d
install -m 0755 src/plugins.d/lsi_hba_temp.plugin %{buildroot}%{_libexecdir}/netdata/plugins.d/lsi_hba_temp.plugin
mkdir -p %{buildroot}%{_sysconfdir}/netdata/health.d
install -m 0644 src/health.d/lsi_hba_temp.conf %{buildroot}%{_sysconfdir}/netdata/health.d/lsi_hba_temp.conf
mkdir -p %{buildroot}%{_docdir}/%{name}
install -m 0644 README.md LICENSE %{buildroot}%{_docdir}/%{name}/

%post
if getent passwd netdata >/dev/null 2>&1 && getent group systemd-journal >/dev/null 2>&1; then
    /usr/sbin/usermod -aG systemd-journal netdata || :
fi
/bin/systemctl try-restart netdata.service >/dev/null 2>&1 || :

%postun
/bin/systemctl try-restart netdata.service >/dev/null 2>&1 || :

%files
%{_libexecdir}/netdata/plugins.d/lsi_hba_temp.plugin
%config(noreplace) %{_sysconfdir}/netdata/health.d/lsi_hba_temp.conf
%doc %{_docdir}/%{name}/README.md
%doc %{_docdir}/%{name}/LICENSE

%changelog
* Sun Jun 21 2026 Cheddar SunRae <info@cheddar.team> - 0.1.0-1
- Initial Netdata integration package for lsi-hba-temp journal output.
