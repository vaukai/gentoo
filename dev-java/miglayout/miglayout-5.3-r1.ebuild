# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.miglayout:miglayout-core:5.0 com.miglayout:miglayout-swing:5.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple virtualx

DESCRIPTION="MiGLayout - Java Layout Manager for Swing, SWT and JavaFX"
HOMEPAGE="https://miglayout.com/"
SRC_URI="https://github.com/mikaelgrev/miglayout/archive/V${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="BSD"
SLOT="5"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"

JAVA_TEST_EXTRA_ARGS=( -Djava.awt.headless=false )
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RUN_ONLY="net.miginfocom.swing.MigLayoutTest"
JAVA_TEST_SRC_DIR="swing/src/test/java"

src_compile() {
	einfo "Compiling miglayout-core.jar"
	JAVA_JAR_FILENAME="miglayout-core.jar"
	JAVA_SRC_DIR="core/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":miglayout-core.jar"
	rm -r target || die

	einfo "Compiling miglayout-wingore.jar"
	JAVA_JAR_FILENAME="miglayout-swing.jar"
	JAVA_SRC_DIR="swing/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":miglayout-swing.jar"
	rm -r target || die

	if use doc; then
		einfo "Compiling javadocs"
		JAVA_SRC_DIR=(
			"core/src/main/java"
			"swing/src/main/java"
		)
		JAVA_JAR_FILENAME="ignoreme.jar"
		java-pkg-simple_src_compile
	fi
}

src_test() {
	virtx java-pkg-simple_src_test
}

src_install() {
	java-pkg_dojar "miglayout-core.jar"
	java-pkg_dojar "miglayout-swing.jar"

	if use doc; then
		java-pkg_dojavadoc target/api
	fi

	if use source; then
		java-pkg_dosrc "core/src/main/java/*"
		java-pkg_dosrc "swing/src/main/java/*"
	fi
}
