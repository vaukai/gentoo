# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# No tests, #839681
JAVA_PKG_IUSE="doc source test"
MAVEN_ID="commons-io:commons-io:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

# inherit java-pkg-2 java-pkg-simple verify-sig junit5
inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Utility classes, stream implementations, file filters, and much more"
HOMEPAGE="https://commons.apache.org/proper/commons-io/"
JPV="1.9.1"
SRC_URI="mirror://apache/commons/io/source/${P}-src.tar.gz
	test? ( https://repo1.maven.org/maven2/org/junit-pioneer/junit-pioneer/${JPV}/junit-pioneer-${JPV}.jar )
	verify-sig? ( https://archive.apache.org/dist/commons/io/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~x86-linux ~ppc-macos"

# Tests are still having compilation errors:
# src/test/java/org/apache/commons/io/file/PathUtilsContentEqualsTest.java:125: error: reference to newFileSystem is ambiguous
#                 FileSystem fileSystem2 = FileSystems.newFileSystem(refDir.resolveSibling(refDir.getFileName() + ".zip"), null)) {
#                                                     ^
#   both method newFileSystem(Path,ClassLoader) in FileSystems and method newFileSystem(Path,Map<String,?>) in FileSystems match
# Also, JUnit5 is not yet supported in ::gentoo eclasses.
RESTRICT="test"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/commons.apache.org.asc"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"

DEPEND="
	>=virtual/jdk-11:*
	test? (
		>=dev-java/commons-codec-1.18.0:0
		>=dev-java/commons-lang-3.18.0:0
		dev-java/jimfs:0
		dev-java/jmh-core:0
		dev-java/junit:5
		dev-java/mockito:4
		dev-java/opentest4j:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_GENTOO_CLASSPATH_EXTRA="${DISTDIR}/junit-pioneer-${JPV}.jar"
JAVA_INTERMEDIATE_JAR_NAME="org.apache.${PN/-/.}"
JAVA_MODULE_INFO_OUT="src/main"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="commons-codec commons-lang jimfs jmh-core junit-5 mockito-4 opentest4j"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"
