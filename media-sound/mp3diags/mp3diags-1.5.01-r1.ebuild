# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils xdg-utils

MY_PN=MP3Diags-unstable
MY_P=${MY_PN}-${PV}

DESCRIPTION="Qt-based MP3 diagnosis and repair tool"
HOMEPAGE="http://mp3diags.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-3 GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-libs/boost:=
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	sys-libs/zlib
"
RDEPEND="${DEPEND}
	dev-qt/qtsvg:5
"

src_prepare() {
	# unused dependency - bug #711086
	sed -i -e "/^network/d" src/src.pro || die

	default
}

src_configure() {
	eqmake5 ${PN}.pro
}

src_install() {
	dobin bin/${MY_PN}
	dodoc changelog.txt

	local size
	for size in 16 22 24 32 36 40 48; do
		insinto /usr/share/icons/hicolor/${size}x${size}/apps
		newins desktop/${MY_PN}${size}.png ${MY_PN}.png
	done
	domenu desktop/${MY_PN}.desktop
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
