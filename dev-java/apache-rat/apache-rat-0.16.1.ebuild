# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# No tests, #839681
JAVA_PKG_IUSE="doc source"
MAVEN_PROVIDES="
	org.apache.rat:apache-rat-core:${PV}
	org.apache.rat:apache-rat-tasks:${PV}
"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Apache Rat is a release audit tool, focused on licenses"
HOMEPAGE="https://creadur.apache.org/rat/"
SRC_URI="https://archive.apache.org/dist/creadur/${P}/${P}-src.tar.bz2
	verify-sig? ( https://archive.apache.org/dist/creadur/${P}/${P}-src.tar.bz2.asc )"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/creadur.apache.org.asc"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-creadur )"

CP_DEPEND="
	>=dev-java/ant-1.10.15:0
	>=dev-java/commons-beanutils-1.10.1:0
	>=dev-java/commons-cli-1.9.0:0
	dev-java/commons-collections:4
	dev-java/commons-compress:0
	>=dev-java/commons-io-2.18.0:1
	>=dev-java/commons-lang-3.17.0:3.6
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( NOTICE README.md README.txt RELEASE-NOTES.txt RELEASE_NOTES.txt )
#	PATCHES=( "${FILESDIR}/apache-rat-0.15-fix-tests.patch" )

JAVADOC_SRC_DIRS=( apache-rat-{core,tasks}/src/main/java )

src_compile() {
	einfo "Compiling apache-rat-core.jar"
	JAVA_JAR_FILENAME="${PN}-core.jar"
	JAVA_RESOURCE_DIRS="${PN}-core/src/main/resources"
	JAVA_SRC_DIR="${PN}-core/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":${PN}-core.jar"
	rm -r target || die

	einfo "Compiling apache-rat-tasks.jar"
	JAVA_JAR_FILENAME="${PN}-tasks.jar"
	JAVA_RESOURCE_DIRS="${PN}-tasks/src/main/resources"
	JAVA_SRC_DIR="${PN}-tasks/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":${PN}-tasks.jar"
	rm -r target || die

	# javadoc is broken for java 17, see https://bugs.gentoo.org/914458
	JAVADOC_CLASSPATH="${JAVA_GENTOO_CLASSPATH}"
	use doc && ejavadoc
}

src_install() {
	java-pkg_dojar "${PN}-core.jar"
	java-pkg_dojar "${PN}-tasks.jar"
	java-pkg_dolauncher "${PN}" --main org.apache.rat.Report

	use doc && java-pkg_dojavadoc target/api

	if use source; then
		java-pkg_dosrc "${PN}-core/src/main/java/*"
		java-pkg_dosrc "${PN}-tasks/src/main/java/*"
	fi
}
