# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# No tests
JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apache.commons:commons-collections4:${PV}"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Extends the JCF classes with new interfaces, implementations and utilities"
HOMEPAGE="https://commons.apache.org/proper/commons-collections/"
SRC_URI="mirror://apache/commons/collections/source/${PN}4-${PV/_pre/-M}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/commons/collections/source/${PN}4-${PV/_pre/-M}-src.tar.gz.asc )"
S="${WORKDIR}/commons-collections4-${PV}-src"

LICENSE="Apache-2.0"
SLOT="4.5"
KEYWORDS="~amd64 ~arm64 ~ppc64"

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}/usr/share/openpgp-keys/commons.apache.org.asc"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"
DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( {CONTRIBUTING,README}.md {NOTICE,RELEASE-NOTES}.txt )
HTML_DOCS=( {DEVELOPERS-GUIDE,PROPOSAL}.html )

JAVA_AUTOMATIC_MODULE_NAME="org.apache.commons.collections4"
JAVA_SRC_DIR="src/main/java"

src_compile() {
	JAVA_JAR_FILENAME="org.apache.${PN}.jar"
	java-pkg-simple_src_compile	# creates a legacy jar file without module-info

	jdeps --generate-module-info \
		src/main/java \
		--multi-release 9 \
		"${JAVA_JAR_FILENAME}" || die

	JAVA_JAR_FILENAME="${PN}.jar"
	java-pkg-simple_src_compile	# creates the final jar file including module-info
}
