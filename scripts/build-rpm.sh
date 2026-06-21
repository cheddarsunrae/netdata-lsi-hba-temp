#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
set -euo pipefail
VERSION="0.1.0"
NAME="netdata-lsi-hba-temp"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
mkdir -p rpm-build/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
tar --exclude='./rpm-build' --exclude='.git' -czf "rpm-build/SOURCES/${NAME}-${VERSION}.tar.gz" --transform "s,^,${NAME}-${VERSION}/," README.md LICENSE src packaging scripts
cp packaging/rpm/${NAME}.spec rpm-build/SPECS/
rpmbuild --define "_topdir $ROOT/rpm-build" -ba "rpm-build/SPECS/${NAME}.spec"
find rpm-build/RPMS rpm-build/SRPMS -type f
