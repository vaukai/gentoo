# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="OpenVZ VPS disk quota utility"
HOMEPAGE="http://openvz.org/download/utils/vzquota/"
SRC_URI="http://download.openvz.org/utils/${PN}/${PV}/src/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc64 ~sparc x86"

src_prepare() {
	default

	sed -e 's,$(INSTALL) -s -m,$(INSTALL) -m,' \
		-e 's:$(CC) $(CFLAGS) -o:$(CC) $(CFLAGS) $(LDFLAGS) -o:' \
		-e 's:-Werror ::' \
		-i "${S}/src/Makefile" || die "sed on src/Makefile failed"

	tc-export CC
}

src_install() {
	emake DESTDIR="${ED}" INSTALL="${EPREFIX}/usr/bin/install" install
	keepdir /var/vzquota

	# remove accidentally created man8 dir
	rm -r "${ED}/man8" || die "remove man8 directory failed"
}
