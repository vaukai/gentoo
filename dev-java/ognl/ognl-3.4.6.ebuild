# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# No tests, #
JAVA_PKG_IUSE="doc source"
MAVEN_ID=""
MAVEN_PROVIDES=""

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Object Graph Navigation Library"
HOMEPAGE="https://ognl.orphan.software/"
SRC_URI="https://github.com/orphan-oss/ognl/archive/OGNL_${PV//./_}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/ognl-OGNL_${PV//./_}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND=""

JAVACC_SLOT="7.0.13"
BDEPEND="dev-java/javacc:${JAVACC_SLOT}"
DEPEND="
	${CP_DEPEND}
	dev-java/javassist:3
	>=virtual/jdk-1.8:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_AUTOMATIC_MODULE_NAME="ognl"
JAVA_CLASSPATH_EXTRA="javassist-3"
JAVA_SRC_DIR="src/main/java"

src_prepare() {
	java-pkg-2_src_prepare
	"javacc-${JAVACC_SLOT}" \
		-GRAMMAR_ENCODING=UTF-8 \
		-LOOKAHEAD=1, -STATIC=false \
		-JAVA_UNICODE_ESCAPE=true \
		-UNICODE_INPUT=true \
		-OUTPUT_DIRECTORY=src/main/java \
		src/main/javacc/ognl.jj
}
