# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_DATE=$(ver_cut 4)
MY_PV=$(ver_cut 1-3)_${MY_DATE:0:4}_${MY_DATE:4:2}_${MY_DATE:6}
MY_P_OTF="LinLibertineOTF_${MY_PV}"
MY_P_TTF="LinLibertineTTF_${MY_PV}"

inherit font

DESCRIPTION="Fonts from the Linux Libertine Open Fonts Project"
HOMEPAGE="https://libertine-fonts.org/"
SRC_URI="https://downloads.sourceforge.net/linuxlibertine/${MY_P_OTF}.tgz
	https://downloads.sourceforge.net/linuxlibertine/${MY_P_TTF}.tgz"
S="${WORKDIR}"

LICENSE="|| ( GPL-2-with-font-exception OFL-1.1 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~loong ppc ppc64 ~riscv sparc x86"
IUSE=""

RDEPEND="!<x11-libs/pango-1.20.4"

DOCS=( Bugs.txt ChangeLog.txt README Readme-TEX.txt )

FONT_SUFFIX="otf ttf"
