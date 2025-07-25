# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=0.006
inherit perl-module

DESCRIPTION="Receive notification when something changes a file's contents"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/Dist-Zilla-4.300.39
	dev-perl/Moose
	dev-perl/Safe-Isa
	dev-perl/namespace-autoclean
"
DEPEND="
	dev-perl/Module-Build-Tiny
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.39.0
	test? (
		dev-perl/Module-Runtime
		dev-perl/Path-Tiny
		dev-perl/Test-Deep
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.880.0
	)
"
