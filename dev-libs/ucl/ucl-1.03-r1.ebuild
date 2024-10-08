# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="the UCL Compression Library"
HOMEPAGE="http://www.oberhumer.com/opensource/ucl/"
SRC_URI="http://www.oberhumer.com/opensource/ucl/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ppc ppc64 sparc x86"
IUSE="static-libs"

DEPEND="!!dev-libs/libucl"

PATCHES=(
	"${FILESDIR}"/${P}-CFLAGS.patch
	"${FILESDIR}"/${P}-x32.patch #426334
)

src_prepare() {
	default

	# lzo (and ucl) have some weird sort of mfx_* set of autoconf macros
	# which may only be distributed with lzo itself? Rescue them and
	# place them into acinclude.m4 because there doesn't seem to be an
	# m4/...
	sed -n -e '/^AC_DEFUN.*mfx_/,/^])#$/p' aclocal.m4 > acinclude.m4 || die "Unable to rescue mfx_* autoconf macros."

	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.ac || die

	eautoreconf
}

src_configure() {
	# bug #585632
	append-cflags -std=c90

	econf \
		--enable-shared \
		$(use_enable static-libs static)
}

src_install() {
	default

	find "${ED}" -type f -name '*.la' -delete || die
}
