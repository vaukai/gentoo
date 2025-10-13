# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# No tests, #839681
JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apache.bcel:bcel:6.10.0"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Apache Commons Bytecode Engineering Library"
HOMEPAGE="https://commons.apache.org/proper/commons-bcel/"
SRC_URI="mirror://apache/commons/bcel/source/${P}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/commons/bcel/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/ggregory.asc"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-ggregory )"
CP_DEPEND="
	>=dev-java/commons-io-2.20.0:0
	>=dev-java/commons-lang-3.19.0:0
"
DEPEND="${CP_DEPEND}
	>=virtual/jdk-11:*"
RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DOCS=( NOTICE.txt RELEASE-NOTES.txt )

JAVA_INTERMEDIATE_JAR_NAME="org.apache.${PN/-/.}"
JAVA_MODULE_INFO_OUT="src/main"
JAVA_SRC_DIR="src/main/java"
