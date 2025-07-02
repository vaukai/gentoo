# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic java-pkg-2 toolchain-funcs

DESCRIPTION="NativeThread for priorities on linux for freenet"
HOMEPAGE="https://github.com/hyphanet/contrib/blob/master/README"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

CDEPEND=">=dev-java/jna-5.17.0:0"

DEPEND="
	${CDEPEND}
	net-p2p/freenet
	>=virtual/jdk-1.8:*
"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.8:*
"

PATCHES=( "${FILESDIR}/NativeThread-0_pre20190914-r3-javah.patch" )

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
}

src_compile() {
	append-flags -fPIC
	tc-export CC
	emake
}

src_install() {
	dolib.so lib${PN}.so
	dosym lib${PN}.so /usr/$(get_libdir)/libnative.so
}
