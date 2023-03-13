# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.sleepycat:je:18.3.12"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Berkley Database Java Edition - build and runtime support."
HOMEPAGE="http://www.oracle.com/technetwork/database/database-technologies/nosqldb"
SRC_URI="https://repo1.maven.org/maven2/com/sleepycat/je/${PV}/je-${PV}-sources.jar -> ${P}-sources.jar"
S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="
	dev-java/ant-core:0
	dev-java/javax-resource-api:0
	dev-java/checker-framework-qual:0
"
DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
"
RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"
BDEPEND="app-arch/unzip"

JAVA_MAIN_CLASS="com.sleepycat.je.utilint.JarMain"

src_prepare() {
	java-pkg-2_src_prepare
	rm -r com/sleepycat/je/jca/ra || die
	rm -r com/sleepycat/je/rep/jmx/plugin || die
}
