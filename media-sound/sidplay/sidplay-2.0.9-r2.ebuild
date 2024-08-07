# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="C64 SID player"
HOMEPAGE="https://sidplay2.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/sidplay2/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ppc ~sparc x86"

BDEPEND="virtual/pkgconfig"
DEPEND="media-libs/libsidplay:2"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-gcc43.patch"
	"${FILESDIR}/${P}-gcc44.patch"
	"${FILESDIR}/${P}-drop-register-keyword.patch"
)
