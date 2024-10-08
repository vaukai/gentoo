# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=KENTNL
DIST_VERSION=1.001002
inherit perl-module

DESCRIPTION="Create a Fake ShareDir for your modules for testing"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Class-Tiny
	>=virtual/perl-Exporter-5.570.0
	dev-perl/File-Copy-Recursive
	>=dev-perl/File-ShareDir-1.0.0
	>=dev-perl/Path-Tiny-0.18.0
	dev-perl/Scope-Guard
	virtual/perl-parent
"
BDEPEND="virtual/perl-ExtUtils-MakeMaker
	${RDEPEND}
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		virtual/perl-File-Spec
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.960.0
	)
"
