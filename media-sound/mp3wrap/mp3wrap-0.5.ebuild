# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Command-line utility that wraps multiple mp3 files into one large playable mp3"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}-src.tar.gz"
HOMEPAGE="https://mp3wrap.sourceforge.net/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

PATCHES=( "${FILESDIR}"/${P}-Wimplicit-function-declaration.patch )

src_prepare() {
	default

	eautoreconf
}

src_install() {
	dobin mp3wrap

	doman mp3wrap.1
	local HTML_DOCS=( doc/*.html )
	einstalldocs
}
