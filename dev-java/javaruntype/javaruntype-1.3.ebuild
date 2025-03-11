# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.javaruntype:javaruntype:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="runtime type system for Java"
HOMEPAGE="https://www.javaruntype.org"
SRC_URI="https://github.com/javaruntype/javaruntype/archive/${P}.tar.gz"
S="${WORKDIR}/javaruntype-${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND=""

DEPEND="
	${CP_DEPEND}
	dev-java/antlr-runtime:3.5
	>=virtual/jdk-1.8:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_CLASSPATH_EXTRA="antlr-runtime-3.5"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_SRC_DIR="src/test/java"
