# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Implementation of the HTML5 parsing algorithm in Java"
HOMEPAGE="https://about.validator.nu/htmlparser/"
SRC_URI="https://about.validator.nu/${PN}/${P}.zip"

LICENSE="W3C"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="
	dev-java/icu4j:69
	dev-java/jchardet:0
	dev-java/xom:0"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.8:*"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.8:*"

BDEPEND="
	app-arch/unzip"

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src"
JAVA_GENTOO_CLASSPATH="icu4j-69,xom,jchardet"
