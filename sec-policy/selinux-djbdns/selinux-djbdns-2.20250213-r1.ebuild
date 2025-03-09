# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

MODS="djbdns"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for djbdns"

if [[ ${PV} != 9999* ]] ; then
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi
DEPEND="${DEPEND}
	sec-policy/selinux-daemontools
	sec-policy/selinux-ucspitcp
"
RDEPEND="${RDEPEND}
	sec-policy/selinux-daemontools
	sec-policy/selinux-ucspitcp
"
